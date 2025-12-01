import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/core/services/settings_service.dart';
import 'package:pawcus/features/pet/service.dart';
import 'package:pawcus/features/pet/storage.dart';
import 'package:pawcus/services/auth_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator({
  AuthService? authService,
}) async {
  // Load Dependencies
  final appUsageService = AppUsageService();
  final permissionsService = PermissionsService();
  sl.registerSingleton(appUsageService);
  sl.registerSingleton(permissionsService);
  sl.registerSingleton<AuthService>(authService ?? FirebaseAuthService());

  sl.registerSingletonAsync<CacheService>(() async {
    final prefs = await SharedPreferences.getInstance();
    final svc = CacheService(prefs);

    return svc;
  });
  await sl.isReady<CacheService>();
  sl.registerLazySingleton<SettingsService>(
    () => SettingsService(sl<CacheService>()),
  );

  // Init PetService
  final legacyPetService = LegacyPetService(appUsageService, permissionsService);
  sl.registerSingleton(legacyPetService);
  sl.registerSingleton(PetService(storage: SharedPrefsPetStorage(), legacyService: legacyPetService));
}
