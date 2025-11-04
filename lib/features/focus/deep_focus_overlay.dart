import 'dart:async';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

// Give the user the possibility to return to the app in 10 seconds
// Give the user the option to cancel focus session and lose the progress
// It makes your pet sad

@pragma('vm:entry-point')
class DeepFocusOverlay extends StatefulWidget {
  const DeepFocusOverlay({super.key});

  @override
  State<DeepFocusOverlay> createState() => _DeepFocusOverlayState();
}

class _DeepFocusOverlayState extends State<DeepFocusOverlay> {
  static const int initialSeconds = 15;
  int secondsRemaining = initialSeconds;
  Timer? _timer;
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _messageSubscription = FlutterOverlayWindow.overlayListener.listen((event) {
      if (event == 'start') {
        setState(() {
          secondsRemaining = initialSeconds;
          _startTimer();
        });
      }
    });
  }

  @override
  void dispose() {
    _messageSubscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          timer.cancel();
          // Timer finished actions will go here
          cancelFocus();
        }
      });
    });
  }

  void returnToApp() async {
    await LaunchApp.openApp(
      androidPackageName: 'com.scovillestudios.pawcus', // your app id
      openStore: false,
    );
    FlutterOverlayWindow.closeOverlay(); // replace for focus service w/ close overlay
  }

  void cancelFocus() async {
    await FlutterOverlayWindow.shareData("stopFocus");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(180),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Your Pet is Deep Focused!",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            const SizedBox(height: 16),
            Text(
              "Return to Pawcus in $secondsRemaining seconds, or you can cancel the focus session.",
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: returnToApp,
                  icon: Icon(Icons.keyboard_double_arrow_left_rounded),
                  tooltip: "Return to App",
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                      (states) => Colors.green,
                    ),
                  ),
                ),
                IconButton.filled(
                  onPressed: () async {
                    print("mensaje enviao");
                    await FlutterOverlayWindow.shareData("asdfasdf");
                  },
                  tooltip: "Cancel Focus",
                  icon: Icon(Icons.cancel),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.resolveWith(
                      (states) => Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
