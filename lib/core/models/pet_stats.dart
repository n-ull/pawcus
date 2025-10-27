class PetStats {
  final double happiness; // 0.0 - 1.0
  final double energy; // 0.0 - 1.0
  final double hunger; // 0.0 - 1.0
  final double thirst; // 0.0 - 1.0
  final double sleep; // 0.0 - 1.0
  final double hygiene; // 0.0 - 1.0

  PetStats({
    required this.happiness,
    required this.energy,
    required this.hunger,
    required this.thirst,
    required this.sleep,
    required this.hygiene,
  }) : assert(happiness >= 0.0 && happiness <= 1.0),
       assert(energy >= 0.0 && energy <= 1.0),
       assert(hunger >= 0.0 && hunger <= 1.0),
       assert(thirst >= 0.0 && thirst <= 1.0),
       assert(sleep >= 0.0 && sleep <= 1.0),
       assert(hygiene >= 0.0 && hygiene <= 1.0);

  PetStats copyWith({
    double? happiness,
    double? energy,
    double? hunger,
    double? thirst,
    double? sleep,
    double? hygiene,
  }) {
    return PetStats(
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      hunger: hunger ?? this.hunger,
      thirst: thirst ?? this.thirst,
      sleep: sleep ?? this.sleep,
      hygiene: hygiene ?? this.hygiene,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'happiness': happiness,
      'energy': energy,
      'hunger': hunger,
      'thirst': thirst,
      'sleep': sleep,
      'hygiene': hygiene,
    };
  }

  static PetStats fromMap(Map<String, dynamic> map) {
    return PetStats(
      happiness: map['happiness'],
      energy: map['energy'],
      hunger: map['hunger'],
      thirst: map['thirst'],
      sleep: map['sleep'],
      hygiene: map['hygiene'],
    );
  }
}
