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
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filled(
                    icon: Icon(Icons.bolt_rounded),
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                    ),
                  ),
                  IconButton.filled(
                    icon: Icon(Icons.lunch_dining_rounded),
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                    ),
                  ),
                  IconButton.filled(
                    icon: Icon(Icons.emoji_emotions_rounded),
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                    ),
                  ),
                  IconButton.filled(
                    icon: Icon(Icons.bedtime),
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.green),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Expanded(child: Center(child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(100))
                ),
              ))),
            ],
          ),
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
