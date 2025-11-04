import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class OverlayService {
  Future<void> showOverlay(dynamic currentApp) async {
    if (await FlutterOverlayWindow.isActive()) return;
    
    await FlutterOverlayWindow.showOverlay(
      height: WindowSize.fullCover,
      width: WindowSize.fullCover,
      enableDrag: false,
      overlayTitle: "Deep Focus Mode",
      flag: OverlayFlag.defaultFlag,
      visibility: NotificationVisibility.visibilityPublic,
      alignment: OverlayAlignment.center,
      startPosition: OverlayPosition(0, 0),
    );
    
    // Send message to start the timer
    await Future.delayed(const Duration(milliseconds: 500));
    await FlutterOverlayWindow.shareData('start');
  }

  Future<void> hideOverlay() async {
    if (!await FlutterOverlayWindow.isActive()) return;
    await FlutterOverlayWindow.closeOverlay();
  }
}
