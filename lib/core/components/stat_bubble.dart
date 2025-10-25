import 'package:flutter/material.dart';

class StatBubble extends StatelessWidget {
  final String label;
  final double data;
  final IconData icon;

  Color calculateColor() {
    if (data < 0.3) {
      return Colors.red;
    } else if (data < 0.7) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  const StatBubble({
    super.key,
    required this.label,
    required this.data,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          value: data,
          strokeWidth: 5.0,
          valueColor: AlwaysStoppedAnimation<Color>(calculateColor()),
          backgroundColor: Colors.grey[200],
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: data),
          duration: const Duration(milliseconds: 500),
          builder: (context, value, child) {
            return CircularProgressIndicator(
              value: value,
              strokeWidth: 5.0,
              valueColor: AlwaysStoppedAnimation<Color>(calculateColor()),
              backgroundColor: Colors.grey[200],
            );
          },
        ),

        Icon(icon, color: calculateColor(), size: 30),
      ],
    );
  }
}