import 'package:flutter/material.dart';
import 'package:pawcus/core/components/stat_bubble.dart';
import 'package:pawcus/features/pet/models.dart';

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
            data: pet.petStats.energy,
            icon: Icons.bolt_rounded,
            label: 'Energy',
          ),
          StatBubble(
            data: pet.petStats.hunger,
            icon: Icons.lunch_dining_rounded,
            label: 'Hunger',
          ),
          StatBubble(
            data: pet.petStats.happiness,
            icon: Icons.emoji_emotions_rounded,
            label: 'Energy',
          ),
          StatBubble(
            label: 'Sleep',
            data: pet.petStats.sleep,
            icon: Icons.nightlight_round_rounded,
          ),
        ],
      ),
    );
  }
}
