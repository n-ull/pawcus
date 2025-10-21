import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:pawcus/core/router/routes.dart';
import 'package:pawcus/core/services/permissions_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          ],
        ),
      ),
    );
  }
}
