import 'package:shared_preferences/shared_preferences.dart';

import 'package:pawcus/features/pet/models.dart';


class MissingPetDataException implements Exception {
  final String message;

  const MissingPetDataException([this.message = 'Missing pet data in storage']);

  @override
  String toString() => 'MissingPetDataException: $message';
}


abstract class PetStorage {
  Future<void> save(Pet pet);
  Future<Pet> load();
  Future<void> savePetStats(PetStats stats);
  Future<PetStats> loadPetStats();
}


class SharedPrefsPetStorage implements PetStorage {
  @override
  Future<void> save(Pet pet) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor('id'), pet.id);
    await prefs.setString(_keyFor('name'), pet.name);
    await prefs.setInt(_keyFor('level'), pet.level);
    await prefs.setDouble(_keyFor('experience'), pet.experience);
    await prefs.setInt(_keyFor('lastUpdate'), pet.lastUpdate.millisecondsSinceEpoch);
    await savePetStats(pet.petStats);
  }

  @override
  Future<void> savePetStats(PetStats stats) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final subKeys = ['STATS'];

    await prefs.setDouble(_keyFor('happiness', subKeys: subKeys), stats.happiness);
    await prefs.setDouble(_keyFor('energy', subKeys: subKeys), stats.energy);
    await prefs.setDouble(_keyFor('hunger', subKeys: subKeys), stats.hunger);
    await prefs.setDouble(_keyFor('thirst', subKeys: subKeys), stats.thirst);
    await prefs.setDouble(_keyFor('sleep', subKeys: subKeys), stats.sleep);
    await prefs.setDouble(_keyFor('hygiene', subKeys: subKeys), stats.hygiene);
  }

  @override
  Future<Pet> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_keyFor('id'));
    final name = prefs.getString(_keyFor('name'));

    if (id == null || name == null) {
      throw MissingPetDataException('ID or name not found in shared preferences');
    }

    final lastUpdateString = prefs.getInt(_keyFor('lastUpdate'));
    final DateTime lastUpdate;
    if (lastUpdateString == null) {
      lastUpdate = DateTime.now();
    } else {
      lastUpdate = DateTime.fromMillisecondsSinceEpoch(lastUpdateString);
    }

    return Pet(
      id: id,
      name: name,
      level: prefs.getInt(_keyFor('level')) ?? 1,
      experience: prefs.getDouble(_keyFor('experience')) ?? 0,
      lastUpdate: lastUpdate,
      petStats: await loadPetStats(),
    );
  }

  @override
  Future<PetStats> loadPetStats() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final subKeys = ['STATS'];
    final double happiness = prefs.getDouble(_keyFor('happiness', subKeys: subKeys)) ?? 0.5;
    final double energy = prefs.getDouble(_keyFor('energy', subKeys: subKeys)) ?? 0.5;
    final double hunger = prefs.getDouble(_keyFor('hunger', subKeys: subKeys)) ?? 0.5;
    final double thirst = prefs.getDouble(_keyFor('thirst', subKeys: subKeys)) ?? 0.5;
    final double sleep = prefs.getDouble(_keyFor('sleep', subKeys: subKeys)) ?? 0.5;
    final double hygiene = prefs.getDouble(_keyFor('hygiene', subKeys: subKeys)) ?? 0.5;

    return PetStats(
      happiness: happiness,
      energy: energy,
      hunger: hunger,
      thirst: thirst,
      sleep: sleep,
      hygiene: hygiene,
    );
  }
}


String _keyFor(String key, {List<String>? subKeys}) {
  final String prefix;
  if (subKeys == null) {
    prefix = 'PET__';
  } else {
    prefix = 'PET__${subKeys.join("__")}';
  }
  return '$prefix$key';
}
