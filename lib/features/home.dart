import 'package:flutter/material.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:pawcus/core/models/pet.dart';
import 'package:pawcus/core/router/routes.dart';
import 'package:pawcus/core/services/pet_service.dart';
import 'package:pawcus/core/services/service_locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final pet = sl<PetService>().pet;

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
              builder: (context, value, child) => Text(value.name),
            ),
          ],
        ),
      ),
    );
  }
}
