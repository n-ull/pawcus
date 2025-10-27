import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:go_router_plus/go_router_plus.dart';

import 'package:pawcus/core/models/app_usage_entry.dart';
import 'package:pawcus/core/services/pet_service.dart';
import 'package:pawcus/core/services/service_locator.dart';
import 'package:pawcus/features/focus/focus_screen.dart';
import 'package:pawcus/features/pet/pet_screen.dart';
import 'package:pawcus/features/settings/settings_screen.dart';


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
          if (index == 3) {
            context.go("/login");
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          Icon(CupertinoIcons.paw_solid),
          Icon(CupertinoIcons.cloud),
          Icon(CupertinoIcons.gear_solid),
          Icon(CupertinoIcons.arrow_right_circle_fill),
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
      PetScreen(pet: pet),
      FocusScreen(),
      SettingsScreen(),
    ][_currentIndex];
  }
}
