import 'package:flutter/material.dart';
import 'package:pawcus/core/components/paw_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PawScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Holi')
        ],
      ),
    );
  }
}