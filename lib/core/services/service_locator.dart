import 'package:get_it/get_it.dart';
import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/core/services/pet_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Load Dependencies
  sl.registerSingleton(AppUsageService());
  sl.registerSingleton(PermissionsService());

  // Init PetService
  sl.registerSingletonAsync<PetService>(() async {
    final svc = PetService();
    await svc.init();
    return svc;
  });

  await sl.isReady<PetService>();
}