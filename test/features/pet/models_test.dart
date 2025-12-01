import 'package:test/test.dart';

import 'package:pawcus/features/pet/models.dart';


void main() {
  group('Pet model', () {
    final petStats = PetStats(happiness: 1, energy: 0.3, hunger: 0, thirst: 0.62, sleep: 0.13, hygiene: 0.27);

    test('Create an instance only with required fields', () {
      final pet = Pet(
        id: '1',
        name: 'Erbscito',
        petStats: petStats,
        lastUpdate: DateTime(2025, 11, 11),
      );

      // Check provided fields
      expect(pet.id, '1');
      expect(pet.name, 'Erbscito');
      expect(pet.lastUpdate, DateTime(2025, 11, 11));
      expect(pet.petStats, petStats);

      // Check default fields
      expect(pet.level, 1);
      expect(pet.experience, 0);
    });

    test('Create an instance including optional fields', () {
      final pet = Pet(
        id: '1',
        name: 'Erbscito',
        petStats: petStats,
        lastUpdate: DateTime(2025, 11, 11),
        level: 5,
        experience: 83,
      );

      expect(pet.level, 5);
      expect(pet.experience, 83);
    });

    test('toMap correctly dumps all information', () {
      final petMap = Pet(
        id: '1',
        name: 'Erbscito',
        petStats: petStats,
        lastUpdate: DateTime(2025, 11, 11),
        level: 5,
        experience: 83,
      ).toMap();

      expect(petMap['id'], '1');
      expect(petMap['name'], 'Erbscito');
      expect(petMap['lastUpdate'], DateTime(2025, 11, 11).millisecondsSinceEpoch);
      expect(petMap['level'], 5);
      expect(petMap['experience'], 83);
      expect(petMap['petStats'], isA<Map<String, double>>());
    });

    test('fromMap correctly loads all information', () {
      final pet = Pet.fromMap({
        "id": '1',
        "name": 'Erbscito',
        "petStats": petStats.toMap(),
        "lastUpdate": DateTime(2025, 11, 11).millisecondsSinceEpoch,
        "level": 5,
        "experience": 83,
      });

      expect(pet.id, '1');
      expect(pet.name, 'Erbscito');
      expect(pet.lastUpdate, DateTime(2025, 11, 11));
      expect(pet.petStats, isA<PetStats>());
      expect(pet.level, 5);
      expect(pet.experience, 83);
    });

    test('fromMap with default values', () {
      final pet = Pet.fromMap({
        "id": '1',
        "name": 'Erbscito',
        "lastUpdate": DateTime(2025, 11, 11).millisecondsSinceEpoch,
      });

      expect(pet.id, '1');
      expect(pet.name, 'Erbscito');
      expect(pet.lastUpdate, DateTime(2025, 11, 11));
      expect(pet.petStats, isA<PetStats>());
      expect(pet.petStats.happiness, 0.5);
      expect(pet.petStats.energy, 0.5);
      expect(pet.petStats.hunger, 0.5);
      expect(pet.petStats.thirst, 0.5);
      expect(pet.petStats.sleep, 0.5);
      expect(pet.petStats.hygiene, 0.5);
      expect(pet.level, 1);
      expect(pet.experience, 0);
    });

    test('copyWith generates new instance with provided values', () {
      final pet = Pet(
        id: '1',
        name: 'Erbscito',
        petStats: petStats,
        lastUpdate: DateTime(2025, 11, 11),
        level: 5,
        experience: 83,
      );

      final datetime = DateTime.now();
      final newPet = pet.copyWith(
        experience: 5,
        level: 2,
        lastUpdate: datetime,
        petStats: petStats.copyWith(hygiene: 1),
      );

      expect(newPet, isA<Pet>());
      expect(newPet, isNot(pet));
      expect(newPet.id, '1');
      expect(newPet.name, 'Erbscito');
      expect(newPet.lastUpdate, datetime);
      expect(newPet.petStats.happiness, pet.petStats.happiness);
      expect(newPet.petStats.energy, pet.petStats.energy);
      expect(newPet.petStats.hunger, pet.petStats.hunger);
      expect(newPet.petStats.thirst, pet.petStats.thirst);
      expect(newPet.petStats.sleep, pet.petStats.sleep);
      expect(newPet.petStats.hygiene, 1);
      expect(newPet.level, 2);
      expect(newPet.experience, 5);
    });
  });

  group('PetStats model', () {
    test('Create instance', () {
      final petStats = PetStats(
        happiness: 1,
        energy: 0.3,
        hunger: 0,
        thirst: 0.62,
        sleep: 0.13,
        hygiene: 0.27,
      );

      expect(petStats.happiness, 1);
      expect(petStats.energy, 0.3);
      expect(petStats.hunger, 0);
      expect(petStats.thirst, 0.62);
      expect(petStats.sleep, 0.13);
      expect(petStats.hygiene, 0.27);
    });

    test('toMap correctly dumps all information', () {
      final petStatsMap = PetStats(
        happiness: 0.88,
        energy: 1,
        hunger: 0,
        thirst: 0.76,
        sleep: 0.12,
        hygiene: 0.99,
      ).toMap();

      expect(petStatsMap['happiness'], 0.88);
      expect(petStatsMap['energy'], 1);
      expect(petStatsMap['hunger'], 0);
      expect(petStatsMap['thirst'], 0.76);
      expect(petStatsMap['sleep'], 0.12);
      expect(petStatsMap['hygiene'], 0.99);
    });

    test('fromMap correctly loads all information', () {
      final petStats = PetStats.fromMap({
        'happiness': 0.88,
        'energy': 1,
        'hunger': 0,
        'thirst': 0.76,
        'sleep': 0.12,
        'hygiene': 0.99,
      });

      expect(petStats.happiness, 0.88);
      expect(petStats.energy, 1);
      expect(petStats.hunger, 0);
      expect(petStats.thirst, 0.76);
      expect(petStats.sleep, 0.12);
      expect(petStats.hygiene, 0.99);
    });

    test('copyWith generates new instance with provided values', () {
      final petStats = PetStats(
        happiness: 0.78,
        energy: 0.3,
        hunger: 0.5,
        thirst: 0.92,
        sleep: 0.08,
        hygiene: 0.09,
      );

      final newPetStats = petStats.copyWith(
        happiness: 1,
        sleep: 0.35,
        hunger: 0.5,
      );

      expect(newPetStats, isA<PetStats>());
      expect(newPetStats, isNot(petStats));
      expect(newPetStats.happiness, 1);
      expect(newPetStats.energy, 0.3);
      expect(newPetStats.hunger, 0.5);
      expect(newPetStats.thirst, 0.92);
      expect(newPetStats.sleep, 0.35);
      expect(newPetStats.hygiene, 0.09);
    });
  });
}
