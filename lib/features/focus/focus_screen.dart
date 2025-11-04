import 'package:flutter/material.dart';
import 'package:pawcus/core/services/overlay_service.dart';
import 'package:pawcus/core/services/service_locator.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  // should start timer
  // should save session data
  // should activate the overlay system
  // block other options and menus

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 4,
                      color: Colors.black.withAlpha(50),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '25:00',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text("Are you ready to focus?"),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  sl<OverlayService>().showOverlay("com.pipi");
                },
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow_rounded),
                    const Text("Start Focus"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
