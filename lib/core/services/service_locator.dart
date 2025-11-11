import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/core/services/pet_service.dart';
import 'package:pawcus/core/services/settings_service.dart';
import 'package:pawcus/features/pet/repository.dart';
import 'package:pawcus/features/pet/storage.dart';
import 'package:pawcus/services/auth_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator({
  AuthService? authService,
}) async {
  // Load Dependencies
  sl.registerSingleton(AppUsageService());
  sl.registerSingleton(PermissionsService());
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
  sl.registerSingletonAsync<PetService>(() async {
    final svc = PetService(
      sl<AppUsageService>(),
      sl<PermissionsService>(),
      sl<CacheService>(),
    );

    try {
      await svc.init();
    } catch (e, stackTrace) {
      log('Failed to initialize PetService: $e\n$stackTrace');
      rethrow;
    }

    return svc;
  });

  sl.registerSingleton(PetRepository(storage: SharedPrefsPetStorage()));
  await sl.isReady<PetService>();
}
