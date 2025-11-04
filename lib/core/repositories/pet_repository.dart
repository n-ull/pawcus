import 'package:pawcus/features/pet/models.dart';

abstract class PetRepository {
  Future<Pet?> getPet(String id);
  Future<void> updatePet(Pet pet);
}
