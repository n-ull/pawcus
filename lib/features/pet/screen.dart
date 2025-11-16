import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pawcus/core/components/stats_row.dart';
import 'package:pawcus/core/services/pet_service.dart';
import 'package:pawcus/core/services/service_locator.dart';
import 'package:pawcus/features/pet/models.dart';
import 'package:pawcus/features/pet/repository.dart';


class PetScreen extends StatefulWidget {
  const PetScreen({super.key, required this.petRepository});

  final PetRepository petRepository;

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  late Pet _pet;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPet();
  }

  Future<void> _loadPet() async {
    final pet = await widget.petRepository.getPet() ?? widget.petRepository.getDefaultPet();
    if (!mounted) return;
    setState(() {
      _pet = pet;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        Lottie.asset('assets/lottie/Clouds.json'),
        Column(
          children: buildBody(context),
        ),
      ],
    );
  }

  List<Widget> buildBody(BuildContext context) {
    final children = <Widget>[
      Padding(
        padding: const EdgeInsets.all(16),
        child: StatsRow(pet: _pet),
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
            Text('Lvl. ${_pet.level}'),
            const SizedBox(width: 4),
            Expanded(
              child: LinearProgressIndicator(
                value: widget.petRepository.getExpPercentage(_pet) / 100,
                color: Theme.of(context).colorScheme.inversePrimary,
                semanticsLabel: 'Exp.',
                semanticsValue: widget.petRepository.getExpPercentage(_pet).toString(),
                minHeight: 16,
              ),
            ),
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
    ];

    if (kDebugMode) {
      children.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final newPet = await widget.petRepository.addExp(_pet, -10);
                if (!mounted) return;
                setState(() => _pet = newPet);
              },
              child: Text('-10 exp'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                final newPet = await widget.petRepository.addExp(_pet, 10);
                if (!mounted) return;
                setState(() => _pet = newPet);
              },
              child: Text('+10 exp'),
            ),
          ],
        ),
      );
    }
    return children;
  }
}
