import 'package:flutter/material.dart';
import 'package:pawcus/features/permissions/permissions_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [Text('Settings Screen'), PermissionsScreen()])),
    );
  }
}
