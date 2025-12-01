import 'package:flutter_test/flutter_test.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:pawcus/features/pet/models.dart';
import 'package:pawcus/features/pet/storage.dart';


void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('SharedPrefsPetStorage', () {
    late SharedPrefsPetStorage storage;
    late Pet pet;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final petStats = PetStats(happiness: 1, energy: 0.3, hunger: 0, thirst: 0.62, sleep: 0.13, hygiene: 0.27);
      pet = Pet(
        id: '1',
        name: 'Erbscito',
        petStats: petStats,
        lastUpdate: DateTime(2025, 11, 11),
        level: 5,
        experience: 83,
      );
      storage = SharedPrefsPetStorage();
      prefs = await SharedPreferences.getInstance();
    });

    test('save correctly dumps model base fields', () async {
      final prefix = 'PET__';
      await storage.save(pet);
      expect(prefs.getString('${prefix}id'), pet.id);
      expect(prefs.getString('${prefix}name'), pet.name);
      expect(
        DateTime.fromMillisecondsSinceEpoch(prefs.getInt('PET__lastUpdate')!),
        pet.lastUpdate,
      );
      expect(prefs.getInt('${prefix}level'), pet.level);
      expect(prefs.getDouble('${prefix}experience'), pet.experience);
    });

    test('save correctly dumps model nested fields', () async {
      final prefix = 'PET__STATS__';
      await storage.save(pet);
      expect(prefs.getDouble('${prefix}happiness'), pet.petStats.happiness);
      expect(prefs.getDouble('${prefix}energy'), pet.petStats.energy);
      expect(prefs.getDouble('${prefix}hunger'), pet.petStats.hunger);
      expect(prefs.getDouble('${prefix}thirst'), pet.petStats.thirst);
      expect(prefs.getDouble('${prefix}sleep'), pet.petStats.sleep);
      expect(prefs.getDouble('${prefix}hygiene'), pet.petStats.hygiene);
    });

    test('load correctly sets all fields', () async {
      await storage.save(pet);
      final loadedPet = await storage.load();
      expect(loadedPet, isNot(pet));
      expect(loadedPet.id, pet.id);
      expect(loadedPet.name, pet.name);
      expect(loadedPet.lastUpdate, pet.lastUpdate);
      expect(loadedPet.level, pet.level);
      expect(loadedPet.experience, pet.experience);

      expect(loadedPet.petStats, isNot(pet.petStats));
      expect(loadedPet.petStats.happiness, pet.petStats.happiness);
      expect(loadedPet.petStats.energy, pet.petStats.energy);
      expect(loadedPet.petStats.hunger, pet.petStats.hunger);
      expect(loadedPet.petStats.thirst, pet.petStats.thirst);
      expect(loadedPet.petStats.sleep, pet.petStats.sleep);
      expect(loadedPet.petStats.hygiene, pet.petStats.hygiene);
    });

    test('savePetStats correctly dump all fields', () async {
      final prefix = 'PET__STATS__';
      await storage.savePetStats(pet.petStats);
      expect(prefs.getDouble('${prefix}happiness'), pet.petStats.happiness);
      expect(prefs.getDouble('${prefix}energy'), pet.petStats.energy);
      expect(prefs.getDouble('${prefix}hunger'), pet.petStats.hunger);
      expect(prefs.getDouble('${prefix}thirst'), pet.petStats.thirst);
      expect(prefs.getDouble('${prefix}sleep'), pet.petStats.sleep);
      expect(prefs.getDouble('${prefix}hygiene'), pet.petStats.hygiene);
    });

    test('loadPetStats correctly sets all fields', () async {
      await storage.savePetStats(pet.petStats);
      final stats = await storage.loadPetStats();
      expect(stats, isNot(pet.petStats));
      expect(stats.happiness, pet.petStats.happiness);
      expect(stats.energy, pet.petStats.energy);
      expect(stats.hunger, pet.petStats.hunger);
      expect(stats.thirst, pet.petStats.thirst);
      expect(stats.sleep, pet.petStats.sleep);
      expect(stats.hygiene, pet.petStats.hygiene);
    });
  });
}
