import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:pawcus/core/models/app_usage_entry.dart';
import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/router/routes.dart';
import 'package:pawcus/core/services/app_usage_service.dart';
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
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                context.pushNamed(Routes.permissions.name);
              },
              child: Text('Check Permissions'),
            ),
            ValueListenableBuilder(
              valueListenable: pet,
              builder: (context, value, child) => Column(
                children: [
                  Text(value.name),
                  LabeledText(value.lastUpdate.toString(), 'Last Update: '),
                  LabeledText(
                    value.petStat.happiness.toString(),
                    'Happiness: ',
                  ),
                  LabeledText(value.petStat.energy.toString(), 'Energy: '),
                  LabeledText(value.petStat.hunger.toString(), 'Hunger: '),
                  LabeledText(value.petStat.thirst.toString(), 'Thirst: '),
                  LabeledText(value.petStat.sleep.toString(), 'Sleep: '),
                  LabeledText(value.petStat.hygiene.toString(), 'Hygiene: '),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                sl<PetService>().checkDailyAppUsage();
              },
              child: Text('Check Daily App Usage'),
            ),
          ],
        ),
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
