import 'package:pawcus/core/models/pet_stats.dart';

class Pet {
  final String id;
  final String name;
  final DateTime lastUpdate;
  final PetStats petStat;

  Pet({
    required this.id,
    required this.name,
    required this.lastUpdate,
    required this.petStat,
  });

  Pet copyWith({DateTime? lastUpdate, PetStats? petStat}) {
    return Pet(
      id: id,
      name: name,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      petStat: petStat ?? this.petStat,
    );
  }
}
