
# Gemini Project

This file outlines the project structure and dependencies for the Pawcus Flutter application.

## Project Structure

```
/pawcus/
├───.gitignore
├───.metadata
├───analysis_options.yaml
├───pubspec.lock
├───pubspec.yaml
├───README.md
├───.dart_tool/
├───.git/
├───.idea/
├───android/
├───build/
├───ios/
├───lib/
│   ├───main.dart
│   ├───core/
│   │   ├───constants.dart
│   │   ├───components/
│   │   │   └───paw_scaffold.dart
│   │   ├───exceptions/
│   │   │   └───app_usage_exceptions.dart
│   │   ├───router/
│   │   │   ├───router.dart
│   │   │   └───routes.dart
│   │   └───services/
│   │       ├───api_client.dart
│   │       ├───api_service.dart
│   │       ├───app_usage_service.dart
│   │       ├───permissions_service.dart
│   │       └───service_locator.dart
│   └───features/
│       └───home.dart
├───linux/
├───macos/
├───web/
└───windows/
```

## Dependencies

### Main Dependencies

- **flutter**: The core Flutter framework.
- **cupertino_icons**: iOS-style icons.
- **dio**: A powerful HTTP client for Dart.
- **equatable**: Simplifies equality comparisons.
- **bloc**: A predictable state management library.
- **flutter_bloc**: Flutter widgets that make it easy to integrate blocs and cubits.
- **get_it**: A simple service locator for Dart and Flutter projects.
- **go_router_plus**: A declarative routing package for Flutter.
- **app_usage**: A plugin for querying app usage statistics.
- **android_intent_plus**: A plugin for launching Android intents.
- **flutter_overlay_window**: A plugin for creating overlay windows.

### Dev Dependencies

- **flutter_test**: The Flutter testing framework.
- **flutter_lints**: A set of recommended lints to encourage good coding practices.
