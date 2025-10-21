import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class PermissionsService {
  static const _channel = MethodChannel('com.scovillestudios.pawcus/permissions');

  Future<bool> hasUsageAccess() async {
    if (!Platform.isAndroid) return true;
    try {
      final result = await _channel.invokeMethod('hasUsageAccess');
      return result == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> hasOverlayPermission() async {
    if (!Platform.isAndroid) return true;
    return await FlutterOverlayWindow.isPermissionGranted();
  }

  Future<void> requestAppUsagePermissions() async {
    const intent = AndroidIntent(
      action: 'android.settings.USAGE_ACCESS_SETTINGS',
    );
    await intent.launch();
  }
}
