import 'dart:developer';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

typedef OverlayEventCallback = void Function(String event);

class OverlayChannelService {
  final List<OverlayEventCallback> _subscribers = [];

  OverlayChannelService() {
    // escuchar al canal en el main isolate
    FlutterOverlayWindow.overlayListener.listen((event) {
      log(event);
      for (final callback in _subscribers) {
        callback(event);
      }
    });
  }

  void subscribe(OverlayEventCallback callback) {
    _subscribers.add(callback);
  }

  void unsubscribe(OverlayEventCallback callback) {
    _subscribers.remove(callback);
  }

  /// comunicacion inversa de main a overlay
  Future<void> send(String message) async {
    await FlutterOverlayWindow.shareData(message);
  }
}
