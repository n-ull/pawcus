import 'package:pawcus/core/models/pet.dart';

abstract class PetRepository {
  Pet? getPet(String id);
  Future<void> updatePet(Pet pet);
}
