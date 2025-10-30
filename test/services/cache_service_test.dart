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
   
  });

  test('getPet returns Pet when data exists', () async {
    
  });

  test('getPet returns null when no data', () async {
  });

  test('clear removes stored data', () async {
  });
}