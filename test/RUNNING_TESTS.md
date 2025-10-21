# Running Tests Guide

## Quick Start

```bash
# Install dependencies (including yaml package for tests)
flutter pub get

# Run all tests
flutter test

# Run specific test suites
flutter test test/config/
flutter test test/integration/
```

## Test Execution Examples

### Run Individual Test Files

```bash
# Pubspec validation
flutter test test/config/pubspec_validation_test.dart

# iOS configuration
flutter test test/config/ios_podfile_validation_test.dart

# macOS configuration
flutter test test/config/macos_podfile_validation_test.dart

# Integration tests
flutter test test/integration/platform_consistency_test.dart
```

### Run Tests with Different Verbosity

```bash
# Verbose output
flutter test --verbose

# Compact output
flutter test --compact

# Show coverage
flutter test --coverage
```

### Run Specific Test Groups

```bash
# Run only pubspec.yaml validation group
flutter test test/config/pubspec_validation_test.dart --name "pubspec.yaml validation"

# Run only iOS Podfile validation group
flutter test test/config/ios_podfile_validation_test.dart --name "iOS Podfile validation"
```

### Run Tests Matching a Pattern

```bash
# Run all tests related to app_usage
flutter test --name "app_usage"

# Run all xcconfig tests
flutter test --name "xcconfig"

# Run all consistency tests
flutter test --name "consistency"
```

## Expected Output

### Successful Test Run