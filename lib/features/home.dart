import 'package:flutter/material.dart';

import 'package:app_usage/app_usage.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:pawcus/core/router/routes.dart';
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
    final permissionsService = PermissionsService();
    final hasUsageAccess = await permissionsService.hasUsageAccess();

    if (!hasUsageAccess) {
      await permissionsService.requestAppUsagePermissions();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('All permissions are granted')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pawcus'),
        backgroundColor: Colors.green,
      ),
      body: Column(children: [
        ElevatedButton(onPressed: checkPermissions, child: Text('Check Permissions')),
        ElevatedButton(onPressed: () => context.go(Routes.login.path), child: Text('Login')),
      ]),
    );
  }
}
