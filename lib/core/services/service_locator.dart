import 'package:get_it/get_it.dart';
import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/core/services/pet_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerSingleton(AppUsageService());
  sl.registerSingleton(PermissionsService());

  sl.registerSingleton(PetService());
  await sl<PetService>().init();

}