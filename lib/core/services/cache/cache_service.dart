import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/models/pet_stats.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  final SharedPreferences prefs;

  // default values
  static const double _defaultStatValue = 0.5;
  static const String _defaultPetName = 'Erbcito';
  static const String _defaultPetId = 'p-1';

  // keys
  static const String _keyHappiness = 'happiness';
  static const String _keyEnergy = 'energy';
  static const String _keyHunger = 'hunger';
  static const String _keyThirst = 'thirst';
  static const String _keySleep = 'sleep';
  static const String _keyHygiene = 'hygiene';
  static const String _keyName = 'name';
  static const String _keyId = 'id';
  static const String _keyLastUpdate = 'lastUpdate';

  CacheService(this.prefs);

  // Obtains only the pet stats from the shared preferences
  PetStats getPetStats() {
    final double happiness =
        prefs.getDouble(_keyHappiness) ?? _defaultStatValue;
    final double energy = prefs.getDouble(_keyEnergy) ?? _defaultStatValue;
    final double hunger = prefs.getDouble(_keyHunger) ?? _defaultStatValue;
    final double thirst = prefs.getDouble(_keyThirst) ?? _defaultStatValue;
    final double sleep = prefs.getDouble(_keySleep) ?? _defaultStatValue;
    final double hygiene = prefs.getDouble(_keyHygiene) ?? _defaultStatValue;

    return PetStats(
      happiness: happiness,
      energy: energy,
      hunger: hunger,
      thirst: thirst,
      sleep: sleep,
      hygiene: hygiene,
    );
  }

  // Obtains the pet from local shared preferences
  Pet getPet() {
    final petStats = getPetStats();
    final name = prefs.getString(_keyName) ?? _defaultPetName;
    final id = prefs.getString(_keyId) ?? _defaultPetId;
    final lastUpdate = prefs.getString(_keyLastUpdate) != null
        ? DateTime.tryParse(prefs.getString(_keyLastUpdate)!) ?? DateTime.now()
        : DateTime.now();

    return Pet(id: id, name: name, lastUpdate: lastUpdate, petStat: petStats);
  }

  // Saves only the pet stats to local shared preferences
  Future<void> savePetStats(PetStats petStats) async {
    await Future.wait([
      prefs.setDouble(_keyHappiness, petStats.happiness),
      prefs.setDouble(_keyEnergy, petStats.energy),
      prefs.setDouble(_keyHunger, petStats.hunger),
      prefs.setDouble(_keyThirst, petStats.thirst),
      prefs.setDouble(_keySleep, petStats.sleep),
      prefs.setDouble(_keyHygiene, petStats.hygiene),
    ]);
  }

  // Saves the pet to local shared preferences
  Future<void> savePet(Pet pet) async {
    await Future.wait([
      savePetStats(pet.petStat),
      prefs.setString(_keyName, pet.name),
      prefs.setString(_keyId, pet.id),
      prefs.setString(_keyLastUpdate, pet.lastUpdate.toIso8601String()),
    ]);
  }
}
