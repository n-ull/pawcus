import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';
import 'package:pawcus/core/services/focus_service.dart';
import 'package:pawcus/core/services/overlay_channel_service.dart';
import 'package:pawcus/core/services/overlay_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/core/services/pet_service.dart';
import 'package:pawcus/core/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Load Dependencies
  sl.registerSingleton(PermissionsService());
  sl.registerSingleton(AppUsageService());

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

  await sl.isReady<PetService>();

  sl.registerLazySingleton(() => OverlayChannelService());
  sl.registerLazySingleton(() => OverlayService());

  sl.registerLazySingleton(
    () => FocusService(
      appUsageService: sl<AppUsageService>(),
      permissionsService: sl<PermissionsService>(),
      overlayService: sl<OverlayService>(),
      overlayChannelService: sl<OverlayChannelService>(),
    ),
  );

  // subscribe actions
  sl<OverlayChannelService>().subscribe((event) async {
    if (event == 'stopFocus') {
      await sl<FocusService>().stopFocusSession();
    }

    print(event);
  });
}
