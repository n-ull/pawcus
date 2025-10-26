import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/core/services/pet_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Load Dependencies
  sl.registerSingleton(AppUsageService());
  sl.registerSingleton(PermissionsService());

  sl.registerSingletonAsync<CacheService>(() async {
    final prefs = await SharedPreferences.getInstance();
    final svc = CacheService(prefs);

    return svc;
  });

  await sl.isReady<CacheService>();
  
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

  await sl.isReady<PetService>();
}
