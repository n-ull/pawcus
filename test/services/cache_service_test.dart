import 'package:flutter_test/flutter_test.dart';
import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/models/pet_stats.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';
import '../mocks/fake_cache_service.dart';

void main() {
  late FakeCacheClient fakeClient;
  late CacheService cacheService;

  setUp(() {
    fakeClient = FakeCacheClient();
    cacheService = FakeCacheService(fakeClient);
  });

  Pet makeTestPet() => Pet(
        id: 'p-1',
        name: 'Erbcito',
        lastUpdate: DateTime.fromMillisecondsSinceEpoch(1000),
        petStat: PetStats(
          happiness: 0.5,
          energy: 0.5,
          hunger: 0.5,
          thirst: 0.5,
          sleep: 0.5,
          hygiene: 0.5,
        ),
      );

  test('savePet stores pet map in underlying client', () async {
    final pet = makeTestPet();

    await cacheService.savePet(pet);

    // FakeCacheClient stores values in-memory
    expect(fakeClient.containsKey('pet'), isTrue);
    final stored = fakeClient.get<Map<String, dynamic>>('pet');
    expect(stored, equals(pet.toMap()));
  });

  test('getPet returns Pet when data exists', () async {
    final pet = makeTestPet();
    // Put directly into fake client store
    await fakeClient.set('pet', pet.toMap());

    final result = cacheService.getPet();

    expect(result, isNotNull);
    expect(result!.id, pet.id);
    expect(result.name, pet.name);
    expect(result.petStat.happiness, pet.petStat.happiness);
  });

  test('getPet returns null when no data', () async {
    final result = cacheService.getPet();
    expect(result, isNull);
  });

  test('clear removes stored data', () async {
    final pet = makeTestPet();
    await fakeClient.set('pet', pet.toMap());
    expect(fakeClient.containsKey('pet'), isTrue);

    await cacheService.clear();

    expect(fakeClient.containsKey('pet'), isFalse);
    expect(cacheService.getPet(), isNull);
  });
}