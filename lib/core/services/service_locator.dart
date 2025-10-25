import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/cache/cache_client.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/core/services/pet_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Load Dependencies
  sl.registerSingleton(AppUsageService());
  sl.registerSingleton(PermissionsService());

  // Init CacheService
  sl.registerSingletonAsync<CacheService>(() async {
    try {
      // initialize hive
      final dir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(dir.path);
      final box = await Hive.openBox('cache');

      // make the cacheclient and service
      final cacheClient = CacheClient(box);
      final svc = CacheService(cacheClient);

      return svc;
    } catch (e, stackTrace) {
      log('Failed to initialize CacheService: $e\n$stackTrace');
      rethrow;
    }
  });

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
