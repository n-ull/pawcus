import 'package:flutter_test/flutter_test.dart';
import 'package:pawcus/core/services/service_locator.dart';
import 'package:pawcus/services/auth_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:pawcus/features/pet/models.dart';
import 'package:pawcus/features/pet/storage.dart';
import 'package:pawcus/features/pet/service.dart';

import '../../mocks/mock_firebase_auth.dart';


void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    TestWidgetsFlutterBinding.ensureInitialized();
    final auth = FirebaseAuthService(auth: TestFirebaseAuth());
    await setupServiceLocator(authService: auth);
  });

  group('PetService', () {
    late Pet pet;
    late PetService service;

    setUp(() async {
      final petStats = PetStats(happiness: 1, energy: 0.3, hunger: 0, thirst: 0.62, sleep: 0.13, hygiene: 0.27);
      pet = Pet(
          id: '1',
          name: 'Erbscito',
          petStats: petStats,
          lastUpdate: DateTime(2025, 11, 11),
          level: 5,
          experience: 83,
        );
        service = PetService(storage: SharedPrefsPetStorage(), legacyService: sl<LegacyPetService>());
    });

    group('getPet', () {
      test('returns null when nothing is stored', () async {
        final loadedPet = await service.getPet();
        expect(loadedPet, isNull);
      });

      test('correctly loads the pet data', () async {
        await service.storage.save(pet);
        final loadedPet = (await service.getPet())!;
        expect(loadedPet, isA<Pet>());
        expect(loadedPet.id, pet.id);
        expect(loadedPet.name, pet.name);
        expect(loadedPet.lastUpdate, pet.lastUpdate);
        expect(loadedPet.level, pet.level);
        expect(loadedPet.experience, pet.experience);

        expect(loadedPet.petStats.happiness, pet.petStats.happiness);
        expect(loadedPet.petStats.energy, pet.petStats.energy);
        expect(loadedPet.petStats.hunger, pet.petStats.hunger);
        expect(loadedPet.petStats.thirst, pet.petStats.thirst);
        expect(loadedPet.petStats.sleep, pet.petStats.sleep);
        expect(loadedPet.petStats.hygiene, pet.petStats.hygiene);
      });
    });

    test('savePet correctly dumps the model', () async {
      final savedPet = await service.savePet(pet);
      final prefs = await SharedPreferences.getInstance();
      final prefix = 'PET__';
      final statsPrefix = '${prefix}STATS__';
      expect(prefs.getString('${prefix}id'), pet.id);
      expect(prefs.getString('${prefix}name'), pet.name);
      // savePet updates the lastUpdated field
      expect(
        prefs.getInt('PET__lastUpdate')!,
        closeTo(savedPet.lastUpdate.millisecondsSinceEpoch.toDouble(), 0.1),
      );
      expect(prefs.getInt('${prefix}level'), pet.level);
      expect(prefs.getDouble('${prefix}experience'), pet.experience);
      expect(prefs.getDouble('${statsPrefix}happiness'), pet.petStats.happiness);
      expect(prefs.getDouble('${statsPrefix}energy'), pet.petStats.energy);
      expect(prefs.getDouble('${statsPrefix}hunger'), pet.petStats.hunger);
      expect(prefs.getDouble('${statsPrefix}thirst'), pet.petStats.thirst);
      expect(prefs.getDouble('${statsPrefix}sleep'), pet.petStats.sleep);
      expect(prefs.getDouble('${statsPrefix}hygiene'), pet.petStats.hygiene);
    });

    group('getExpRequired', () {
      test('getExpRequired returns 100 for level 1', () {
        expect(service.getExpRequired(pet.copyWith(level: 1)), 100);
      });

      test('getExpRequired increases by 10 per level', () {
        expect(service.getExpRequired(pet.copyWith(level: 2)), 110);
        expect(service.getExpRequired(pet.copyWith(level: 5)), 140);
        expect(service.getExpRequired(pet.copyWith(level: 23)), 320);
        expect(service.getExpRequired(pet.copyWith(level: 132)), 1410);
      });

      test('getExpRequired is linear and monotonic', () {
        expect(
          service.getExpRequired(pet.copyWith(level: 19)),
          greaterThan(service.getExpRequired(pet.copyWith(level: 18))),
        );
      });
    });

    group('getExpPercentage', () {
      test('getExpPercentage returns 0% at start', () {
        expect(service.getExpPercentage(pet.copyWith(level: 1, experience: 0)), 0);
        expect(service.getExpPercentage(pet.copyWith(level: 23, experience: 0)), 0);
      });

      test('getExpPercentage returns 50% at halfway', () {
        expect(service.getExpPercentage(pet.copyWith(level: 1, experience: 50)), 50);
        expect(service.getExpPercentage(pet.copyWith(level: 23, experience: 160)), 50);
      });

      test('getExpPercentage returns 100% when threshold is met', () {
        expect(service.getExpPercentage(pet.copyWith(level: 1, experience: 100)), 100);
        expect(service.getExpPercentage(pet.copyWith(level: 32, experience: 410)), 100);
      });

      test('getExpPercentage clamps overflows to 100', () {
        expect(service.getExpPercentage(pet.copyWith(level: 1, experience: 140)), 100);
        expect(service.getExpPercentage(pet.copyWith(level: 5, experience: 8000)), 100);
      });

      test('getExpPercentage clamps negative experience to 0', () {
        expect(service.getExpPercentage(pet.copyWith(level: 1, experience: -20)), 0);
        expect(service.getExpPercentage(pet.copyWith(level: 8, experience: -128)), 0);
      });

      test('getExpPercentage uses level-aware required exp', () {
        final experienceNeededAt3 = service.getExpPercentage(pet.copyWith(level: 3, experience: 30));
        final experienceNeededAt5 = service.getExpPercentage(pet.copyWith(level: 5, experience: 30));
        expect(experienceNeededAt3, isNot(equals(experienceNeededAt5)));
        expect(experienceNeededAt3, greaterThan(experienceNeededAt5));
      });
    });

    test('getDefaultPet returns a valid instance', () async {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      // Make sure timestamp is smaller than default DateTime.now()
      await Future.delayed(const Duration(milliseconds: 10));
      final defaultPet = service.getDefaultPet();

      expect(defaultPet, isA<Pet>());
      expect(defaultPet.id, 'p-1');
      expect(defaultPet.name, 'Erbcito');
      expect(defaultPet.lastUpdate.millisecondsSinceEpoch, greaterThan(timestamp));
      expect(defaultPet.level, 1);
      expect(defaultPet.experience, 0);

      expect(defaultPet.petStats, isA<PetStats>());
      expect(defaultPet.petStats.happiness, 0.5);
      expect(defaultPet.petStats.energy, 0.5);
      expect(defaultPet.petStats.hunger, 0.5);
      expect(defaultPet.petStats.thirst, 0.5);
      expect(defaultPet.petStats.sleep, 0.5);
      expect(defaultPet.petStats.hygiene, 0.5);
    });

    group('addExp', () {
      test('simple add case without leveling up', () async {
        final newPet = await service.addExp(pet.copyWith(level: 1, experience: 10), 5);
        expect(newPet.level, 1);
        expect(newPet.experience, 15);
      });

      test('simple subtract case without leveling down', () async {
        final newPet = await service.addExp(pet.copyWith(level: 1, experience: 10), -5);
        expect(newPet.level, 1);
        expect(newPet.experience, 5);
      });

      test('correctly sets level and experience when leveling up', () async {
        Pet newPet = await service.addExp(pet.copyWith(level: 1, experience: 10), 91);
        expect(newPet.level, 2);
        expect(newPet.experience, 0);

        newPet = await service.addExp(pet.copyWith(level: 120, experience: 1280), 11);
        expect(newPet.level, 121);
        expect(newPet.experience, 0);
      });

      test('level will not bump if experience exactly meets the upper threshold', () async {
        Pet newPet = await service.addExp(pet.copyWith(level: 1, experience: 10), 90);
        expect(newPet.level, 1);
        expect(newPet.experience, 100);

        newPet = await service.addExp(pet.copyWith(level: 120, experience: 1280), 10);
        expect(newPet.level, 120);
        expect(newPet.experience, 1290);
      });

      test('correctly sets level and experience when leveling down', () async {
        Pet newPet = await service.addExp(pet.copyWith(level: 2, experience: 10), -20);
        expect(newPet.level, 1);
        expect(newPet.experience, 100);

        newPet = await service.addExp(pet.copyWith(level: 121, experience: 280), -281);
        expect(newPet.level, 120);
        expect(newPet.experience, 1290);
      });

      test('level will not decrease if experience exactly meets the lower threshold', () async {
        Pet newPet = await service.addExp(pet.copyWith(level: 2, experience: 10), -10);
        expect(newPet.level, 2);
        expect(newPet.experience, 0);

        newPet = await service.addExp(pet.copyWith(level: 121, experience: 80), -80);
        expect(newPet.level, 121);
        expect(newPet.experience, 0);
      });
    });
  });
}
