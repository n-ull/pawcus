import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:pawcus/core/services/permissions_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AppUsageInfo> _infos = [];

  @override
  void initState() {
    super.initState();
  }

  void checkPermissions() async {
    if (!mounted) return;
    final permissionsService = PermissionsService();
    final hasUsageAccess = await permissionsService.hasUsageAccess();
    final hasOverlayPermission = await permissionsService
        .hasOverlayPermission();

    if (!hasUsageAccess) {
      await permissionsService.requestAppUsagePermissions();
    }
    if (!hasOverlayPermission) {
      await permissionsService.requestOverlayPermissions();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('All permissions are granted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: checkPermissions,
              child: Text('Check Permissions'),
            ),
          ],
        ),
      ),
    );
  }
}
