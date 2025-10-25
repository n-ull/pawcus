import 'dart:developer';

import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/services/cache/cache_client.dart';

class CacheService {
  final CacheClient _cacheClient;

  CacheService(this._cacheClient);

  Future<void> savePet(Pet pet) async {
    await _cacheClient.set('pet', pet.toMap());
  }

  Pet? getPet() {
    final petMap = _cacheClient.get<Map<String, dynamic>>('pet');
    if (petMap == null) return null;

    log(petMap.toString());

    return Pet.fromMap(petMap);
  }

  Future<void> clear() async {
    await _cacheClient.clear();
  }
}
