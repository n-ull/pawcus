import 'package:flutter/foundation.dart';
import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/models/pet_stats.dart';

class PetService {
  late final ValueNotifier<Pet> pet;

  Future<void> init() async {
    final loadedPet = await _loadPet();
    pet = ValueNotifier(loadedPet);
  }

  void updatePetStats(PetStats newStats) {
    pet.value.petStat = newStats;
    pet.value.lastUpdate = DateTime.now();
    _savePet();
  }

  Future<Pet> _loadPet() async {
    // mockup a pet
    return Pet(
      id: "peter-1",
      name: "Peter",
      lastUpdate: DateTime.now(),
      petStat: PetStats(
        happiness: 0.5,
        energy: 0.5,
        hunger: 0.5,
        thirst: 0.50,
        sleep: 0.5,
        hygiene: 0.5,
      ),
    );
  }

  Future<void> _savePet() async {
    // save a pet in cache
    throw UnimplementedError("Method not implemented");
  }
}
