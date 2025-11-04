import 'package:pawcus/core/logger.dart';
import 'package:pawcus/features/pet/models.dart';
import 'package:pawcus/features/pet/storage.dart';


class PetRepository {
  final PetStorage storage;

  PetRepository({required this.storage});

  Future<Pet?> getPet() async {
    try {
      return await storage.load();
    } on MissingPetDataException catch(e) {
      logger.info(e.toString());
      return null;
    }
  }

  Future<Pet> savePet(Pet pet) async {
    final newPet = pet.copyWith(lastUpdate: DateTime.now());
    await storage.save(newPet);
    return newPet;
  }

  double getExpPercentage(Pet pet) {
    return (pet.experience * 100 / getExpRequired(pet)).clamp(0, 100);
  }

  int getExpRequired(Pet pet) {
    return 100 + (pet.level - 1) * 10;
  }

  Pet getDefaultPet() {
    return Pet(
      id: 'p-1',
      name: 'Erbcito',
      lastUpdate: DateTime.now(),
      petStats: PetStats(
        happiness: 0.5,
        energy: 0.5,
        hunger: 0.5,
        thirst: 0.5,
        sleep: 0.5,
        hygiene: 0.5,
      ),
    );
  }

  Future<Pet> addExp(Pet pet, double exp) async {
    double newExp = pet.experience + exp;
    int newLevel = pet.level;
    if (newExp > getExpRequired(pet)) {
      newLevel++;
      newExp = 0;
    } else if (newExp < 0) {
      if (newLevel > 1) {
        newLevel--;
        newExp = getExpRequired(pet.copyWith(level: newLevel)).toDouble();
      } else {
        newExp = 0;
      }
    }
    final updatedPet = pet.copyWith(level: newLevel, experience: newExp);
    await savePet(updatedPet);
    return updatedPet;
  }
}
