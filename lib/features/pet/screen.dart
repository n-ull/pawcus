import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pawcus/core/components/stats_row.dart';
import 'package:pawcus/features/pet/models.dart';
import 'package:pawcus/features/pet/service.dart';


class PetScreen extends StatefulWidget {
  const PetScreen({super.key, required this.petService});

  final PetService petService;

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
    final pet = await widget.petService.getPet() ?? widget.petService.getDefaultPet();
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
                value: widget.petService.getExpPercentage(_pet) / 100,
                color: Theme.of(context).colorScheme.inversePrimary,
                semanticsLabel: 'Exp.',
                semanticsValue: widget.petService.getExpPercentage(_pet).toString(),
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
            onPressed: () async {
              final newPet = await widget.petService.updatePet(
                _pet,
                stats: PetStats(
                  happiness: 0,
                  energy: 0,
                  hunger: 0,
                  thirst: 0,
                  sleep: 0,
                  hygiene: 0,
                ),
              );
              if (!mounted) return;
              setState(() => _pet = newPet);
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
        onPressed: () async {
          final newPet = await widget.petService.checkDailyAppUsage(_pet);
          if (!mounted) return;
            setState(() => _pet = newPet);
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
                final newPet = await widget.petService.addExp(_pet, -10);
                if (!mounted) return;
                setState(() => _pet = newPet);
              },
              child: Text('-10 exp'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                final newPet = await widget.petService.addExp(_pet, 10);
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
