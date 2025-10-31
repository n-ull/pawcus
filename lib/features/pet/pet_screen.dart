import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pawcus/core/components/stats_row.dart';
import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/models/pet_stats.dart';
import 'package:pawcus/core/services/pet_service.dart';
import 'package:pawcus/core/services/service_locator.dart';

class PetScreen extends StatelessWidget {
  const PetScreen({super.key, required this.pet, required this.experiencePercentage}) : assert(
    experiencePercentage >= 0 && experiencePercentage <= 100,
    'experiencePercentage must be between 0 and 100'
  );

  final ValueNotifier<Pet> pet;
  final double experiencePercentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Lottie.asset('assets/lottie/Clouds.json'),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ValueListenableBuilder<Pet>(
                valueListenable: pet,
                builder: (context, currentPet, child) {
                  return StatsRow(pet: currentPet);
                },
              ),
            ),
            SizedBox(height: 128),
            Expanded(child: Column(children: [
              Center(child: Image.asset('assets/pet.png')),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 50,
                  maxWidth: 300,
                ),
                child: Row(children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: experiencePercentage / 100,
                      color: Theme.of(context).colorScheme.inversePrimary,
                      semanticsLabel: 'Exp.',
                      semanticsValue: experiencePercentage.toString(),
                      minHeight: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text("Exp."),
                ]),
              ),
            ])),
            SizedBox(height: 16),
            Row(
              children: [
                // reset all stats (it saves the local data)
                IconButton(
                  onPressed: () {
                    sl<PetService>().updatePetStats(
                      PetStats(
                        happiness: 0,
                        energy: 0,
                        hunger: 0,
                        thirst: 0,
                        sleep: 0,
                        hygiene: 0,
                      ),
                    );
                  },
                  icon: Icon(Icons.restore_from_trash),
                ),
                // print the cache data
                IconButton(
                  onPressed: () {

                  },
                  icon: Icon(Icons.restore_rounded),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                sl<PetService>().checkDailyAppUsage();
              },
              child: Text('Check Use Access'),
            ),
          ],
        ),
      ],
    );
  }
}
