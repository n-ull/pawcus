import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  final PageController _pageController = PageController();

  int _currentIndex = 0;

  late List<AppUsageEntry> apps;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF74c9ff),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Color(0xFF74c9ff),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(index);
        },
        items: const [
          Icon(CupertinoIcons.paw_solid),
          Icon(CupertinoIcons.cloud),
          Icon(CupertinoIcons.gear_solid),
        ],
        animationCurve: Curves.bounceInOut,
        animationDuration: const Duration(milliseconds: 200),
      ),
      body: PageView(
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          PetScreen(pet: pet),
          FocusScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }
}
