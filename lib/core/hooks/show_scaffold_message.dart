import 'package:flutter/material.dart';

/// Small hook that returns a function to show stylable scaffold messages (SnackBars).
///
/// Usage:
/// ```dart
/// final showMessage = useShowScaffoldMessage(context);
/// // show a success at the bottom
/// await showMessage('Saved', type: MessageType.success);
/// // show a danger message at the top with custom duration
/// await showMessage('Failed to save', type: MessageType.danger, top: true, duration: Duration(seconds: 5));
/// ```
///
/// The returned function hides any current SnackBar before showing the new one.
enum MessageType { success, danger, info, warning, neutral }

typedef ShowScaffoldMessage = Future<void> Function(
  String message, {
  MessageType? type,
  Duration? duration,
  bool? top,
  Color? backgroundColor,
  Color? textColor,
  SnackBarBehavior? behavior,
  EdgeInsets? margin,
});

/// Returns a callable that shows a SnackBar styled according to the provided
/// parameters. This is intentionally implemented as a simple factory.
ShowScaffoldMessage useShowScaffoldMessage(BuildContext context) {
  return (String message, {
    MessageType? type,
    Duration? duration,
    bool? top,
    Color? backgroundColor,
    Color? textColor,
    SnackBarBehavior? behavior,
    EdgeInsets? margin,
  }) async {
    final theme = Theme.of(context);

    final resolvedType = type ?? MessageType.info;
    final resolvedTop = top ?? false;
    final bg = backgroundColor ?? _defaultBackgroundColor(resolvedType, theme);
    final txt = textColor ?? _defaultTextColor(resolvedType, theme);

    final snackBehavior = behavior ?? SnackBarBehavior.floating;

    final defaultMargin = resolvedTop
        ? EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
          )
        : const EdgeInsets.only(bottom: 16, left: 16, right: 16);

    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: txt),
      ),
      backgroundColor: bg,
      duration: duration ?? const Duration(seconds: 3),
      behavior: snackBehavior,
      // only apply margin when using floating behavior
      margin: snackBehavior == SnackBarBehavior.floating ? (margin ?? defaultMargin) : null,
    );

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(snackBar);
  };
}

Color _defaultBackgroundColor(MessageType type, ThemeData theme) {
  switch (type) {
    case MessageType.success:
      return Colors.green[600]!;
    case MessageType.danger:
      return Colors.red[600]!;
    case MessageType.warning:
      return Colors.orange[700]!;
    case MessageType.info:
      // Use primary color for info to keep it themed
      return theme.colorScheme.primary;
    case MessageType.neutral:
      return theme.colorScheme.surface;
  }
}

Color _defaultTextColor(MessageType type, ThemeData theme) {
  switch (type) {
    case MessageType.neutral:
      return theme.colorScheme.onSurface;
    case MessageType.info:
      // onPrimary typically pairs with primary background
      return theme.colorScheme.onPrimary;
    default:
      // colored backgrounds (red/green/orange) look best with white text
      return Colors.white;
  }
}
