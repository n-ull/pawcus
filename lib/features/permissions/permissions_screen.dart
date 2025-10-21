import 'package:flutter/material.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/core/services/service_locator.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  final permissionsService = sl<PermissionsService>();

  bool hasUsageAccess = false;
  bool hasOverlayPermission = false;

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  void checkPermissions() async {
    bool permissionUsage = await permissionsService.hasUsageAccess();
    bool permissionOverlay = await permissionsService.hasOverlayPermission();

    setState(() {
      hasUsageAccess = permissionUsage;
      hasOverlayPermission = permissionOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text("Has Usage Access"),
              trailing: Switch(value: hasUsageAccess, onChanged: (value) {
                // TODO: is not being updated after change
                permissionsService.requestAppUsagePermissions();
              }),
            ),
            ListTile(
              title: Text("Has Overlay Permission"),
              trailing: Switch(
                value: hasOverlayPermission,
                onChanged: (value) {
                  // TODO: is not being updated after change
                  permissionsService.requestOverlayPermissions();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
