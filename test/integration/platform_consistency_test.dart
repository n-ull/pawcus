import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Cross-platform configuration consistency', () {
    test('iOS and macOS Podfiles have consistent analytics setting', () {
      final iosPodfile = File('ios/Podfile');
      final macosPodfile = File('macos/Podfile');

      if (iosPodfile.existsSync() && macosPodfile.existsSync()) {
        final iosContent = iosPodfile.readAsStringSync();
        final macosContent = macosPodfile.readAsStringSync();

        final analyticsDisabled = "ENV['COCOAPODS_DISABLE_STATS'] = 'true'";
        expect(iosContent.contains(analyticsDisabled), isTrue);
        expect(macosContent.contains(analyticsDisabled), isTrue);
      }
    });

    test('iOS and macOS Podfiles have consistent project configurations', () {
      final iosPodfile = File('ios/Podfile');
      final macosPodfile = File('macos/Podfile');

      if (iosPodfile.existsSync() && macosPodfile.existsSync()) {
        final iosContent = iosPodfile.readAsStringSync();
        final macosContent = macosPodfile.readAsStringSync();

        final configs = [
          "'Debug' => :debug",
          "'Profile' => :release",
          "'Release' => :release",
        ];

        for (final config in configs) {
          expect(iosContent.contains(config), isTrue,
              reason: 'iOS should have $config');
          expect(macosContent.contains(config), isTrue,
              reason: 'macOS should have $config');
        }
      }
    });

    test('iOS and macOS both use frameworks', () {
      final iosPodfile = File('ios/Podfile');
      final macosPodfile = File('macos/Podfile');

      if (iosPodfile.existsSync() && macosPodfile.existsSync()) {
        final iosContent = iosPodfile.readAsStringSync();
        final macosContent = macosPodfile.readAsStringSync();

        expect(iosContent.contains('use_frameworks!'), isTrue);
        expect(macosContent.contains('use_frameworks!'), isTrue);
      }
    });

    test('iOS and macOS both have RunnerTests targets', () {
      final iosPodfile = File('ios/Podfile');
      final macosPodfile = File('macos/Podfile');

      if (iosPodfile.existsSync() && macosPodfile.existsSync()) {
        final iosContent = iosPodfile.readAsStringSync();
        final macosContent = macosPodfile.readAsStringSync();

        expect(iosContent.contains("target 'RunnerTests' do"), isTrue);
        expect(macosContent.contains("target 'RunnerTests' do"), isTrue);
        expect(iosContent.contains('inherit! :search_paths'), isTrue);
        expect(macosContent.contains('inherit! :search_paths'), isTrue);
      }
    });

    test('all xcconfig files use optional includes for Pods', () {
      final xcconfigFiles = [
        'ios/Flutter/Debug.xcconfig',
        'ios/Flutter/Release.xcconfig',
        'macos/Flutter/Flutter-Debug.xcconfig',
        'macos/Flutter/Flutter-Release.xcconfig',
      ];

      for (final filePath in xcconfigFiles) {
        final file = File(filePath);
        if (file.existsSync()) {
          final content = file.readAsStringSync();
          expect(content.contains('#include?'), isTrue,
              reason: '$filePath should use optional include for Pods');
        }
      }
    });

    test('Debug and Release configs exist for both platforms', () {
      final debugConfigs = [
        'ios/Flutter/Debug.xcconfig',
        'macos/Flutter/Flutter-Debug.xcconfig',
      ];
      final releaseConfigs = [
        'ios/Flutter/Release.xcconfig',
        'macos/Flutter/Flutter-Release.xcconfig',
      ];

      for (final config in debugConfigs) {
        expect(File(config).existsSync(), isTrue,
            reason: '$config should exist');
      }

      for (final config in releaseConfigs) {
        expect(File(config).existsSync(), isTrue,
            reason: '$config should exist');
      }
    });
  });

  group('Dependency configuration integration', () {
    test('app_usage in pubspec.yaml is locked in pubspec.lock', () {
      final pubspecFile = File('pubspec.yaml');
      final lockFile = File('pubspec.lock');

      expect(pubspecFile.existsSync(), isTrue);
      expect(lockFile.existsSync(), isTrue);

      final pubspecContent = pubspecFile.readAsStringSync();
      final lockContent = lockFile.readAsStringSync();

      expect(pubspecContent.contains('app_usage:'), isTrue);
      expect(lockContent.contains('app_usage:'), isTrue);
    });

    test('CocoaPods configurations exist when app_usage is added', () {
      // app_usage requires platform-specific configurations
      final pubspecFile = File('pubspec.yaml');
      final pubspecContent = pubspecFile.readAsStringSync();

      if (pubspecContent.contains('app_usage:')) {
        // iOS CocoaPods setup should exist
        expect(File('ios/Podfile').existsSync(), isTrue,
            reason: 'iOS Podfile required for app_usage plugin');
        
        // macOS CocoaPods setup should exist
        expect(File('macos/Podfile').existsSync(), isTrue,
            reason: 'macOS Podfile required for app_usage plugin');
      }
    });
  });

  group('Configuration file format validation', () {
    test('all Podfiles are valid Ruby files', () {
      final podfiles = ['ios/Podfile', 'macos/Podfile'];

      for (final podfilePath in podfiles) {
        final file = File(podfilePath);
        if (file.existsSync()) {
          final content = file.readAsStringSync();
          
          // Basic Ruby syntax checks
          final singleQuotes = "'".allMatches(content).length;
          expect(singleQuotes % 2, equals(0),
              reason: '$podfilePath should have balanced single quotes');

          final doubleQuotes = '"'.allMatches(content).length;
          expect(doubleQuotes % 2, equals(0),
              reason: '$podfilePath should have balanced double quotes');
        }
      }
    });

    test('all xcconfig files have valid syntax', () {
      final xcconfigFiles = [
        'ios/Flutter/Debug.xcconfig',
        'ios/Flutter/Release.xcconfig',
        'macos/Flutter/Flutter-Debug.xcconfig',
        'macos/Flutter/Flutter-Release.xcconfig',
      ];

      for (final filePath in xcconfigFiles) {
        final file = File(filePath);
        if (file.existsSync()) {
          final lines = file.readAsLinesSync();
          
          for (var i = 0; i < lines.length; i++) {
            final line = lines[i].trim();
            if (line.isNotEmpty && !line.startsWith('//')) {
              // Should be either a comment or an include directive
              expect(
                line.startsWith('#include') || line.startsWith('//'),
                isTrue,
                reason: 'Line ${i + 1} in $filePath should be include or comment',
              );
            }
          }
        }
      }
    });

    test('YAML files are properly formatted', () {
      final yamlFiles = ['pubspec.yaml', 'pubspec.lock'];

      for (final yamlPath in yamlFiles) {
        final file = File(yamlPath);
        if (file.existsSync()) {
          final content = file.readAsStringSync();
          
          // Should not have tabs
          expect(content.contains('\t'), isFalse,
              reason: '$yamlPath should use spaces, not tabs');
          
          // Should end with newline
          expect(content.endsWith('\n'), isTrue,
              reason: '$yamlPath should end with newline');
        }
      }
    });
  });
}