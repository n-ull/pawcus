import 'package:flutter/foundation.dart';
import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/models/pet_stats.dart';
import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';

class PetService {
  late final ValueNotifier<Pet> pet;
  final PermissionsService _permissionsService;
  final AppUsageService _appUsageService;

  PetService(this._appUsageService, this._permissionsService);

  Future<void> init() async {
    final loadedPet = await _loadPet();
    pet = ValueNotifier(loadedPet);
  }

  void updatePetStats(PetStats newStats) {
    pet.value = pet.value.copyWith(
      petStat: newStats,
      lastUpdate: DateTime.now(),
    );
    _savePet();
  }

  Future<Pet> _loadPet() async {
    // mockup a pet
    return Pet(
      id: "peter-1",
      name: "Peter",
      lastUpdate: DateTime.now(),
      petStat: PetStats(
        happiness: 0.5,
        energy: 0.5,
        hunger: 0.5,
        thirst: 0.50,
        sleep: 0.5,
        hygiene: 0.5,
      ),
    );
  }

  Future<void> _savePet() async {
    // TODO: Implement persistence (e.g., SharedPreferences or local database)
    // For now, this is a no-op to prevent crashes during development
  }

  Future<void> checkDailyAppUsage() async {
    if (!await _permissionsService.hasUsageAccess()) return;

    final usage = await _appUsageService.getAppsUsage(
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now(),
    );
  }
}
