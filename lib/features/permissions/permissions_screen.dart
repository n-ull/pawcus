import 'package:flutter/material.dart';
import 'package:pawcus/core/services/permissions_service.dart';
import 'package:pawcus/core/services/service_locator.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen>
    with WidgetsBindingObserver {
  final permissionsService = sl<PermissionsService>();

  bool hasUsageAccess = false;
  bool hasOverlayPermission = false;

  /// minutes

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkPermissions();
    }
    super.didChangeAppLifecycleState(state);
  }

  Future<void> checkPermissions() async {
    bool permissionUsage = await permissionsService.hasUsageAccess();
    bool permissionOverlay = await permissionsService.hasOverlayPermission();

    setState(() {
      hasUsageAccess = permissionUsage;
      hasOverlayPermission = permissionOverlay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          title: Text("Has Usage Access"),
          subtitle: Text("This is useful for tracking app usage."),
          trailing: Switch(
            value: hasUsageAccess,
            onChanged: (_) async {
              await permissionsService.requestAppUsagePermissions();
              await checkPermissions();
            },
          ),
        ),
        ListTile(
          title: Text("Has Overlay Permission"),
          subtitle: Text("This is useful for ..."),
          trailing: Switch(
            value: hasOverlayPermission,
            onChanged: (_) async {
              await permissionsService.requestOverlayPermissions();
              await checkPermissions();
            },
          ),
        ),
      ],
    );
  }
}
