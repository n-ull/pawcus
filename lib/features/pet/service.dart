import 'package:pawcus/core/logger.dart';
import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/features/pet/models.dart';
import 'package:pawcus/features/pet/storage.dart';


// TODO: Refactor into new service
class LegacyPetService {
  final PermissionsService _permissionsService;
  final AppUsageService _appUsageService;

  // Configurable thresholds / deltas to make behavior testable and tunable
  final int thresholdSeconds;
  final double happinessPenalty;
  final double energyPenalty;
  final double happinessReward;
  final double energyReward;

  LegacyPetService(
    this._appUsageService,
    this._permissionsService,
    {
      this.thresholdSeconds = 2 * 60 * 60,
      this.happinessPenalty = 0.2,
      this.energyPenalty = 0.15,
      this.happinessReward = 0.1,
      this.energyReward = 0.05,
    }
  );

  Future<PetStats> checkDailyAppUsage(Pet pet) async {
    if (!await _permissionsService.hasUsageAccess()) return pet.petStats;

    final usage = await _appUsageService.getAppsUsage(
      DateTime.now().subtract(const Duration(days: 1)),
      DateTime.now(),
    );

    // Algorithm for demo/testing:
    // - Sum total non-system app usage seconds during the period.
    // - If totalUsageSeconds > thresholdSeconds, decrease happiness and energy.
    // - Otherwise, slightly increase happiness/energy.
    final totalUsageSeconds = usage.fold<int>(0, (s, e) => s + e.usageSeconds);

    final currentStats = pet.petStats;
    double newHappiness = currentStats.happiness;
    double newEnergy = currentStats.energy;

    if (totalUsageSeconds > thresholdSeconds) {
      // heavy usage -> penalty
      newHappiness = (newHappiness - happinessPenalty).clamp(0.0, 1.0).toDouble();
      newEnergy = (newEnergy - energyPenalty).clamp(0.0, 1.0).toDouble();
    } else {
      // light usage -> reward
      newHappiness = (newHappiness + happinessReward).clamp(0.0, 1.0).toDouble();
      newEnergy = (newEnergy + energyReward).clamp(0.0, 1.0).toDouble();
    }

    return currentStats.copyWith(
      happiness: newHappiness,
      energy: newEnergy,
    );
  }
}


class PetService {
  final PetStorage storage;
  final LegacyPetService legacyService;

  PetService({required this.storage, required this.legacyService});

  Future<Pet?> getPet() async {
    try {
      return await storage.load();
    } on MissingPetDataException catch(e) {
      logger.info(e.toString());
      return null;
    }
  }

  Future<Pet> savePet(Pet pet) async {
    final newPet = pet.copyWith(lastUpdate: DateTime.now());
    await storage.save(newPet);
    return newPet;
  }

  double getExpPercentage(Pet pet) {
    return (pet.experience * 100 / getExpRequired(pet)).clamp(0, 100).toDouble();
  }

  int getExpRequired(Pet pet) {
    return 100 + (pet.level - 1) * 10;
  }

  Pet getDefaultPet() {
    return Pet(
      id: 'p-1',
      name: 'Erbcito',
      lastUpdate: DateTime.now(),
      petStats: PetStats(
        happiness: 0.5,
        energy: 0.5,
        hunger: 0.5,
        thirst: 0.5,
        sleep: 0.5,
        hygiene: 0.5,
      ),
    );
  }

  Future<Pet> addExp(Pet pet, double exp) async {
    double newExp = pet.experience + exp;
    int newLevel = pet.level;
    if (newExp > getExpRequired(pet)) {
      newLevel++;
      newExp = 0;
    } else if (newExp < 0) {
      if (newLevel > 1) {
        newLevel--;
        newExp = getExpRequired(pet.copyWith(level: newLevel)).toDouble();
      } else {
        newExp = 0;
      }
    }
    final updatedPet = pet.copyWith(level: newLevel, experience: newExp);
    return savePet(updatedPet);
  }

  Future<Pet> updatePet(Pet pet, {int? level, double? experience, PetStats? stats}) async {
    final newPet = pet.copyWith(
      lastUpdate: DateTime.now(),
      level: level,
      experience: experience,
      petStats: stats,
    );
    return savePet(newPet);
  }

  Future<Pet> checkDailyAppUsage(Pet pet) async {
    final newStats = await legacyService.checkDailyAppUsage(pet);
    return updatePet(pet, stats: newStats);
  }
}
