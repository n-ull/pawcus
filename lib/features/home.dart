import 'package:flutter/material.dart';
import 'package:pawcus/core/models/app_usage_entry.dart';
import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/services/pet_service.dart';
import 'package:pawcus/core/services/service_locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pet = sl<PetService>().pet;
  late List<AppUsageEntry> apps;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 32,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.pets_rounded), label: 'Pet'),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement_rounded),
            label: 'Focus',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(pet.value.name, style: TextTheme.of(context).titleLarge),
              ValueListenableBuilder<Pet>(
                valueListenable: pet,
                builder: (context, currentPet, child) {
                  return StatsRow(pet: currentPet);
                },
              ),
              SizedBox(height: 16),
              Expanded(
                child: Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  sl<PetService>().checkDailyAppUsage();
                },
                child: Text('Check Use Access'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

//customized text with label
class LabeledText extends StatelessWidget {
  final String data;
  final String label;
  const LabeledText(this.data, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [Text(label), Text(data)]);
  }
}

class StatBubble extends StatelessWidget {
  final String label;
  final double data;
  final IconData icon;

  Color calculateColor() {
    if (data < 0.3) {
      return Colors.red;
    } else if (data < 0.7) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  const StatBubble({
    super.key,
    required this.label,
    required this.data,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          value: data,
          strokeWidth: 5.0,
          valueColor: AlwaysStoppedAnimation<Color>(calculateColor()),
          backgroundColor: Colors.grey[200],
        ),

        Icon(icon, color: calculateColor(), size: 30),
      ],
    );
  }
}
