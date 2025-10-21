import 'package:flutter/material.dart';

class PawScaffold extends StatelessWidget {
  final Widget body;

  const PawScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
    );
  }
}
