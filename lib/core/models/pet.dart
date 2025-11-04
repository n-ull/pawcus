import 'package:pawcus/core/models/pet_stats.dart';

class Pet {
  final String id;
  final String name;
  final DateTime lastUpdate;
  final PetStats petStats;

  Pet({
    required this.id,
    required this.name,
    required this.lastUpdate,
    required this.petStats,
  });

  Pet copyWith({DateTime? lastUpdate, PetStats? petStats}) {
    return Pet(
      id: id,
      name: name,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      petStats: petStats ?? this.petStats
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
      'petStats': petStats.toMap(),
    };
  }

  static Pet fromMap(Map<String, dynamic> map) {
    return Pet(
      id: map['id'],
      name: map['name'],
      lastUpdate: DateTime.fromMillisecondsSinceEpoch(map['lastUpdate']),
      petStats: PetStats.fromMap(map['petStats']),
    );
  }
}
