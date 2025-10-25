import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
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

  int _currentIndex = 0;
  
  late List<AppUsageEntry> apps;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.lightBlueAccent,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(CupertinoIcons.paw_solid),
          Icon(CupertinoIcons.cloud),
          Icon(CupertinoIcons.gear_solid),
        ],
        animationCurve: Curves.bounceInOut,
        animationDuration: const Duration(milliseconds: 200),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return <Widget>[
      PetStats(pet: pet),
      const Center(child: Text('Cloud Screen')),
      const Center(child: Text('Settings Screen')),
    ][_currentIndex];
  }
}

class PetStats extends StatelessWidget {
  const PetStats({super.key, required this.pet});

  final ValueNotifier<Pet> pet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  pet.value.name, // Access the name from the ValueNotifier's value
                  style: TextTheme.of(context).titleLarge,
                ),
              ),
              SizedBox(height: 16),
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
          );
  }
}

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
            label: 'Happiness',
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
