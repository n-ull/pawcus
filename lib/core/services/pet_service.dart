import 'package:flutter/foundation.dart';
import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/models/pet_stats.dart';
import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';

class PetService {
  late final ValueNotifier<Pet> pet;
  final PermissionsService _permissionsService;
  final AppUsageService _appUsageService;
  final CacheService _cacheService;

  // Configurable thresholds / deltas to make behavior testable and tunable
  final int thresholdSeconds;
  final double happinessPenalty;
  final double energyPenalty;
  final double happinessReward;
  final double energyReward;

  PetService(
    this._appUsageService,
    this._permissionsService,
    this._cacheService, {
    this.thresholdSeconds = 2 * 60 * 60,
    this.happinessPenalty = 0.2,
    this.energyPenalty = 0.15,
    this.happinessReward = 0.1,
    this.energyReward = 0.05,
  });

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
      id: "erbs-1",
      name: "Erbcito",
      lastUpdate: DateTime.now(),
      petStat: PetStats(
        happiness: 0.1,
        energy: 0.9,
        hunger: 0.2,
        thirst: 0.50,
        sleep: 0.1,
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

    // Algorithm for demo/testing:
    // - Sum total non-system app usage seconds during the period.
    // - If totalUsageSeconds > thresholdSeconds, decrease happiness and energy.
    // - Otherwise, slightly increase happiness/energy.
    final totalUsageSeconds = usage.fold<int>(0, (s, e) => s + e.usageSeconds);

    final currentStats = pet.value.petStat;
    double newHappiness = currentStats.happiness;
    double newEnergy = currentStats.energy;

    if (totalUsageSeconds > thresholdSeconds) {
      // heavy usage -> penalty
      newHappiness = (newHappiness - happinessPenalty).clamp(0.0, 1.0);
      newEnergy = (newEnergy - energyPenalty).clamp(0.0, 1.0);
    } else {
      // light usage -> reward
      newHappiness = (newHappiness + happinessReward).clamp(0.0, 1.0);
      newEnergy = (newEnergy + energyReward).clamp(0.0, 1.0);
    }

    final updated = currentStats.copyWith(
      happiness: newHappiness,
      energy: newEnergy,
    );

    updatePetStats(updated);
  }
}
