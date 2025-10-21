# Test Suite for Pawcus Configuration Files

This test suite provides comprehensive validation for the configuration files added to support CocoaPods integration and the `app_usage` dependency.

## Test Structure

### Configuration Tests (`test/config/`)

#### `pubspec_validation_test.dart`
Validates the Flutter project's dependency configuration:
- **pubspec.yaml validation**: Ensures project metadata, dependencies, and Flutter configuration are correct
- **pubspec.lock validation**: Verifies that dependencies are properly locked with integrity hashes
- **Specific checks for app_usage**: Confirms version 4.x.x is correctly added and locked

Key test groups:
- Top-level keys and project metadata
- Environment and SDK constraints
- Dependencies validation (including app_usage)
- Dev dependencies validation
- Flutter configuration
- Publish configuration

#### `ios_podfile_validation_test.dart`
Validates iOS CocoaPods configuration:
- **Podfile structure**: Verifies Ruby syntax, project configurations, and Flutter integration
- **xcconfig files**: Ensures Debug.xcconfig and Release.xcconfig properly include Pods configurations
- **Build settings**: Validates that CocoaPods analytics is disabled and build settings are applied

Key test groups:
- Podfile existence and content validation
- flutter_root function and error handling
- Runner and RunnerTests target configuration
- Post-install hooks
- xcconfig include directives and ordering

#### `macos_podfile_validation_test.dart`
Validates macOS CocoaPods configuration:
- **Platform-specific settings**: Verifies macOS 10.15 minimum version
- **Ephemeral directory handling**: Checks for correct Flutter-Generated.xcconfig paths
- **xcconfig files**: Validates Flutter-Debug.xcconfig and Flutter-Release.xcconfig

Key test groups:
- macOS-specific Podfile configuration
- macOS flutter_macos_podfile_setup integration
- macOS xcconfig files with ephemeral paths
- Build settings and framework usage

### Integration Tests (`test/integration/`)

#### `platform_consistency_test.dart`
Ensures consistency across iOS and macOS configurations:
- **Cross-platform consistency**: Verifies that iOS and macOS have matching configurations where appropriate
- **Dependency integration**: Confirms app_usage dependency integrates with CocoaPods setup
- **File format validation**: Validates Ruby and YAML syntax

Key test groups:
- Analytics settings consistency
- Project configurations matching
- RunnerTests target consistency
- xcconfig optional includes
- Dependency configuration integration
- File format validation (Ruby, xcconfig, YAML)

## Running the Tests

### Prerequisites
Before running tests, ensure the yaml package is installed:
```bash
flutter pub get
```

### Run All Tests
```bash
flutter test
```

### Run Specific Test Files
```bash
# Run pubspec validation tests only
flutter test test/config/pubspec_validation_test.dart

# Run iOS Podfile tests only
flutter test test/config/ios_podfile_validation_test.dart

# Run macOS Podfile tests only
flutter test test/config/macos_podfile_validation_test.dart

# Run integration tests only
flutter test test/integration/platform_consistency_test.dart
```

### Run Tests with Verbose Output
```bash
flutter test --verbose
```

## Test Coverage

These tests provide validation for:

1. **Configuration File Existence**: All required files exist in the correct locations
2. **Syntax Validation**: Ruby, YAML, and xcconfig files have valid syntax
3. **Content Validation**: Configuration directives are present and correct
4. **Version Constraints**: Dependencies use appropriate version constraints
5. **Integration Validation**: Files work together correctly (e.g., pubspec.yaml ↔ pubspec.lock)
6. **Cross-Platform Consistency**: iOS and macOS configurations are consistent where needed
7. **Build Settings**: CocoaPods and Flutter build settings are properly configured
8. **Error Handling**: Configuration files include proper error messages and guards

## What These Tests Validate

### For pubspec.yaml and pubspec.lock:
- ✅ app_usage dependency is added as version ^4.0.1
- ✅ All dependencies have valid version constraints
- ✅ pubspec.lock contains SHA256 integrity hashes
- ✅ No dependency conflicts exist
- ✅ Project metadata follows Dart conventions

### For iOS Configuration:
- ✅ Podfile exists and has correct Ruby syntax
- ✅ CocoaPods analytics is disabled
- ✅ flutter_root function properly locates Flutter SDK
- ✅ Debug.xcconfig and Release.xcconfig include Pods configurations
- ✅ Include order is correct (Pods before Generated)
- ✅ Optional includes (#include?) are used for Pods

### For macOS Configuration:
- ✅ Podfile exists with macOS 10.15 platform specification
- ✅ Ephemeral directory paths are correct
- ✅ Flutter-Debug.xcconfig and Flutter-Release.xcconfig include Pods configurations
- ✅ macOS-specific pod helper functions are called
- ✅ Build settings are properly configured

### For Cross-Platform Consistency:
- ✅ Analytics settings match across platforms
- ✅ Project configurations (Debug, Profile, Release) are consistent
- ✅ Both platforms use frameworks
- ✅ RunnerTests targets are consistently configured
- ✅ All xcconfig files use optional includes

## Understanding Test Failures

### Common Failure Scenarios:

1. **"app_usage package should be added as a dependency"**
   - Cause: app_usage is missing from pubspec.yaml dependencies
   - Fix: Add `app_usage: ^4.0.1` to dependencies section

2. **"iOS Podfile should exist for CocoaPods integration"**
   - Cause: ios/Podfile is missing
   - Fix: Create Podfile with proper Flutter integration

3. **"Pods config should be included before Generated config"**
   - Cause: Include directives in xcconfig are in wrong order
   - Fix: Ensure #include? for Pods comes before #include for Generated.xcconfig

4. **"SHA256 hash should be 64 characters"**
   - Cause: pubspec.lock is corrupted or outdated
   - Fix: Run `flutter pub get` to regenerate pubspec.lock

## Best Practices

1. **Run tests after any configuration changes**: These tests catch common configuration errors
2. **Keep dependencies in sync**: Run `flutter pub get` after modifying pubspec.yaml
3. **Maintain consistency**: When updating one platform's configuration, update the other
4. **Follow Flutter conventions**: These tests enforce Flutter's recommended structure
5. **Preserve formatting**: Configuration files should be well-formatted and readable

## Adding New Tests

When adding new configuration files or dependencies:

1. Add validation tests to ensure the configuration is correct
2. Add integration tests to verify interaction with existing configurations
3. Update this README with test documentation
4. Run all tests to ensure no regressions

## Continuous Integration

These tests are suitable for CI/CD pipelines:
```yaml
# Example GitHub Actions step
- name: Run configuration tests
  run: flutter test test/config/ test/integration/
```

## Notes

- Tests use dart:io to read files from the repository root
- Tests are read-only and do not modify configuration files
- Tests validate both syntax and semantic correctness
- Tests provide descriptive error messages to aid debugging