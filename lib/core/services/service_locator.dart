import 'package:get_it/get_it.dart';
import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/core/services/pet_service.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Load Dependencies
  sl.registerSingleton(AppUsageService());
  sl.registerSingleton(PermissionsService());
  sl.registerSingleton(PetService());

  // Init PetService
  try {
    await sl<PetService>().init();
  } catch (e, stackTrace) {
    // Log the error or handle gracefully
    print('Error initializing PetService: $e\n$stackTrace');
    // Consider: rethrow or initialize with default state
  }
}