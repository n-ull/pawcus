import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

/// A service that handles requesting and checking for permissions.
class PermissionsService {
  static const _channel = MethodChannel('com.scovillestudios.pawcus/permissions');

  /// Checks if the user has granted usage access permissions.
  Future<bool> hasUsageAccess() async {
    if (!Platform.isAndroid) return true;
    try {
      final result = await _channel.invokeMethod('hasUsageAccess');
      return result == true;
    } catch (e) {
      return false;
    }
  }

  /// Checks if the user has granted overlay permissions.
  Future<bool> hasOverlayPermission() async {
    if (!Platform.isAndroid) return true;
    return await FlutterOverlayWindow.isPermissionGranted();
  }

  /// Requests app usage permissions from the user.
  Future<void> requestAppUsagePermissions() async {
    const intent = AndroidIntent(
      action: 'android.settings.USAGE_ACCESS_SETTINGS',
    );
    await intent.launch();
  }
}
