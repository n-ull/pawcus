import 'package:pawcus/core/models/pet_stats.dart';

class Pet {
  final String id;
  final String name;
  DateTime lastUpdate;
  PetStats petStat;

  Pet({
    required this.id,
    required this.name,
    required this.lastUpdate,
    required this.petStat
  });
}
