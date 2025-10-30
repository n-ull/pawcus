import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/models/pet_stats.dart';
import 'package:pawcus/core/models/settings.dart';
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
    await Future.wait([
      prefs.setDouble('happiness', petStats.happiness),
      prefs.setDouble('energy', petStats.energy),
      prefs.setDouble('hunger', petStats.hunger),
      prefs.setDouble('thirst', petStats.thirst),
      prefs.setDouble('sleep', petStats.sleep),
      prefs.setDouble('hygiene', petStats.hygiene),
    ]);
  }

  Future<void> savePet(Pet pet) async {
    await Future.wait([
      savePetStats(pet.petStat),
      prefs.setString('name', pet.name),
      prefs.setString('id', pet.id),
      prefs.setString('lastUpdate', pet.lastUpdate.toIso8601String()),
    ]);
  }

  Future<void> saveSettings(Settings settings) async {
    await Future.wait([
      prefs.setBool('deepFocus', settings.deepFocusEnabled),
      prefs.setBool('hasUsageAccess', settings.notificationsEnabled),
      prefs.setDouble('appUsageThreshold', settings.appUsageThreshold),
    ]);
  }

  Settings getSettings() {
    final deepFocus = prefs.getBool('deepFocus') ?? false;
    final notifications = prefs.getBool('notificationsEnabled') ?? false;
    final appUsageThreshold = prefs.getDouble('appUsageThreshold') ?? 10;

    return Settings(
      deepFocusEnabled: deepFocus,
      notificationsEnabled: notifications,
      appUsageThreshold: appUsageThreshold,
    );
  }
}
