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

  Future<void> savePet(Pet pet) async {
    pet.lastUpdate = DateTime.now();
    await storage.save(pet);
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

  Future<void> addExp(Pet pet, double exp) async {
    pet.experience += exp;
    if (pet.experience > getExpRequired(pet)) {
      pet.level++;
      pet.experience = 0;
    } else if (pet.experience < 0) {
      if (pet.level > 1) {
        pet.level--;
        pet.experience = getExpRequired(pet).toDouble();
      } else {
        pet.experience = 0;
      }
    }
    await savePet(pet);
  }
}
