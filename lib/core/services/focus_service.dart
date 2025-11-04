import 'dart:async';

import 'package:pawcus/core/services/app_usage_service.dart';
import 'package:pawcus/core/services/overlay_channel_service.dart';
import 'package:pawcus/core/services/overlay_service.dart';
import 'package:pawcus/core/services/permissions_service.dart';

class FocusService {
  // TODO: Implement focus session logic
  // This service will be responsible for:
  // - Starting and stopping focus sessions
  // - Managing the overlay window during focus sessions
  // - Tracking focus session duration and other metrics
  // - Notifying other parts of the app about focus session status
  final AppUsageService appUsageService;
  final PermissionsService permissionsService;
  final OverlayService overlayService;
  final OverlayChannelService overlayChannelService;

  Timer? _focusTimer;
  bool _isFocusActive = false;

  FocusService({
    required this.appUsageService,
    required this.permissionsService,
    required this.overlayService,
    required this.overlayChannelService,
  });

  Future<void> startFocusSession(Duration duration) async {
    // check if permissions are activated and show a modal with the permissions settings if not
    _isFocusActive = true;
    _focusTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      await _checkCurrentApp();
    });

    Future.delayed(duration, stopFocusSession);
  }

  Future<void> stopFocusSession() async {
    _focusTimer?.cancel();
    _isFocusActive = false;
  }

  Future<void> _checkCurrentApp() async {
    if (!_isFocusActive) return;

    final currentApp = await appUsageService.getCurrentForegroundApp();
    final allowedApps = await appUsageService.getAllowedApps();

    if (!allowedApps.contains(currentApp.packageName)) {
      overlayService.showOverlay(currentApp);
    } else {
      // hide overlay
      overlayService.hideOverlay();
    }
  }
}
