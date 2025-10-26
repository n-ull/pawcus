import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/models/pet_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final SharedPreferences prefs;

  CacheService(this.prefs);

  Future<PetStats> getPetStats() async {
    final double happiness = prefs.getDouble('happiness') ?? 0.5;
    final double energy = prefs.getDouble('energy') ?? 0.5;
    final double hunger = prefs.getDouble('hunger') ?? 0.5;
    final double thirst = prefs.getDouble('thirst') ?? 0.5;
    final double sleep = prefs.getDouble('sleep') ?? 0.5;
    final double hygiene = prefs.getDouble('hygiene') ?? 0.5;

    return PetStats(
      happiness: happiness,
      energy: energy,
      hunger: hunger,
      thirst: thirst,
      sleep: sleep,
      hygiene: hygiene,
    );
  }

  Future<Pet> getPet() async {
    final petStats = await getPetStats();
    final name = prefs.getString('name') ?? 'Erbcito';
    final id = prefs.getString('id') ?? 'p-1';
    final lastUpdate = prefs.getString('lastUpdate') != null
        ? DateTime.tryParse(prefs.getString('lastUpdate')!) ?? DateTime.now()
        : DateTime.now();

    return Pet(id: id, name: name, lastUpdate: lastUpdate, petStat: petStats);
  }

  Future<void> savePetStats(PetStats petStats) async {
    await prefs.setDouble('happiness', petStats.happiness);
    await prefs.setDouble('energy', petStats.energy);
    await prefs.setDouble('hunger', petStats.hunger);
    await prefs.setDouble('thirst', petStats.thirst);
    await prefs.setDouble('sleep', petStats.sleep);
    await prefs.setDouble('hygiene', petStats.hygiene);
  }

  Future<void> savePet(Pet pet) async {
    await savePetStats(pet.petStat);
    await prefs.setString('name', pet.name);
    await prefs.setString('id', pet.id);
    await prefs.setString('lastUpdate', pet.lastUpdate.toIso8601String());
  }
}
