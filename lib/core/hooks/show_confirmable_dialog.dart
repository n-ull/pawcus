import 'package:flutter/material.dart';

/// Shows a confirmable dialog with customizable title, content, and button text.
/// Returns a Future that completes with:
/// - true if the user confirms
/// - false if the user cancels
/// - null if the dialog is dismissed by tapping outside (if barrierDismissible is true)
Future<bool?> showConfirmableDialog({
  required BuildContext context,
  required String title,
  required String content,
  String? confirmText,
  String? cancelText,
  Color? confirmColor,
  Color? cancelColor,
  bool barrierDismissible = true,
  TextStyle? titleStyle,
  TextStyle? contentStyle,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      final theme = Theme.of(context);
      
      return AlertDialog(
        title: Text(
          title,
          style: titleStyle ?? theme.textTheme.titleLarge,
        ),
        content: Text(
          content,
          style: contentStyle ?? theme.textTheme.bodyMedium,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: cancelColor,
            ),
            child: Text(cancelText ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: confirmColor ?? theme.colorScheme.primary,
            ),
            child: Text(confirmText ?? 'Confirm'),
          ),
        ],
      );
    },
  );
}
