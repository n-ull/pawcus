import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/repositories/pet_repository.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';

class PetRepositoryImpl implements PetRepository {
  final CacheService _cacheService;

  PetRepositoryImpl(this._cacheService);

  @override
  Pet? getPet(String id) {
    return _cacheService.getPet();
  }

  @override
  Future<void> updatePet(Pet pet) {
    return _cacheService.savePet(pet);
  }
}