import 'package:flutter/material.dart';
import 'package:pawcus/core/components/stat_bubble.dart';
import 'package:pawcus/core/models/pet.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StatBubble(
            data: pet.petStat.energy,
            icon: Icons.bolt_rounded,
            label: 'Energy',
          ),
          StatBubble(
            data: pet.petStat.hunger,
            icon: Icons.lunch_dining_rounded,
            label: 'Hunger',
          ),
          StatBubble(
            data: pet.petStat.happiness,
            icon: Icons.emoji_emotions_rounded,
            label: 'Energy',
          ),
          StatBubble(
            label: 'Sleep',
            data: pet.petStat.sleep,
            icon: Icons.nightlight_round_rounded,
          ),
        ],
      ),
    );
  }
}
