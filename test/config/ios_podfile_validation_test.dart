import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('iOS Podfile validation', () {
    late File podfile;
    late List<String> lines;

    setUpAll(() {
      podfile = File('ios/Podfile');
      if (podfile.existsSync()) {
        lines = podfile.readAsLinesSync();
      }
    });

    test('Podfile exists', () {
      expect(podfile.existsSync(), isTrue,
          reason: 'iOS Podfile should exist for CocoaPods integration');
    });

    test('disables CocoaPods analytics', () {
      final content = podfile.readAsStringSync();
      expect(content.contains("ENV['COCOAPODS_DISABLE_STATS'] = 'true'"), isTrue,
          reason: 'Should disable analytics to improve build latency');
    });

    test('defines project configurations', () {
      final content = podfile.readAsStringSync();
      expect(content.contains("project 'Runner'"), isTrue);
      expect(content.contains("'Debug' => :debug"), isTrue);
      expect(content.contains("'Profile' => :release"), isTrue);
      expect(content.contains("'Release' => :release"), isTrue);
    });

    test('defines flutter_root function', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('def flutter_root'), isTrue,
          reason: 'flutter_root function is required for Flutter integration');
    });

    test('flutter_root checks for Generated.xcconfig', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('Generated.xcconfig'), isTrue);
      expect(content.contains('unless File.exist?'), isTrue);
    });

    test('flutter_root raises error if config not found', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('raise'), isTrue);
      expect(content.contains('flutter pub get'), isTrue,
          reason: 'Should guide users to run flutter pub get');
    });

    test('requires podhelper from flutter_tools', () {
      final content = podfile.readAsStringSync();
      expect(content.contains("require File.expand_path"), isTrue);
      expect(content.contains('podhelper'), isTrue);
    });

    test('calls flutter_ios_podfile_setup', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('flutter_ios_podfile_setup'), isTrue,
          reason: 'Required for Flutter iOS setup');
    });

    test('defines Runner target', () {
      final content = podfile.readAsStringSync();
      expect(content.contains("target 'Runner' do"), isTrue);
    });

    test('uses frameworks', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('use_frameworks!'), isTrue,
          reason: 'Required for Swift/Kotlin plugins');
    });

    test('installs all iOS pods', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('flutter_install_all_ios_pods'), isTrue);
    });

    test('defines RunnerTests target', () {
      final content = podfile.readAsStringSync();
      expect(content.contains("target 'RunnerTests' do"), isTrue);
      expect(content.contains('inherit! :search_paths'), isTrue);
    });

    test('has post_install hook', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('post_install do |installer|'), isTrue);
    });

    test('applies Flutter additional iOS build settings', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('flutter_additional_ios_build_settings'), isTrue);
    });

    test('has proper Ruby syntax structure', () {
      final content = podfile.readAsStringSync();
      // Count 'do' and 'end' keywords - they should be balanced
      final doCount = 'do'.allMatches(content).length;
      final endCount = 'end'.allMatches(content).length;
      expect(doCount, equals(endCount),
          reason: 'Ruby do/end blocks should be balanced');
    });

    test('has no trailing whitespace on critical lines', () {
      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trim().isNotEmpty && !line.startsWith('#')) {
          expect(line, equals(line.trimRight()),
              reason: 'Line ${i + 1} should not have trailing whitespace');
        }
      }
    });

    test('file is properly formatted', () {
      final content = podfile.readAsStringSync();
      expect(content.endsWith('\n'), isTrue,
          reason: 'File should end with a newline');
    });
  });

  group('iOS xcconfig validation', () {
    late File debugConfig;
    late File releaseConfig;

    setUpAll(() {
      debugConfig = File('ios/Flutter/Debug.xcconfig');
      releaseConfig = File('ios/Flutter/Release.xcconfig');
    });

    test('Debug.xcconfig exists', () {
      expect(debugConfig.existsSync(), isTrue);
    });

    test('Release.xcconfig exists', () {
      expect(releaseConfig.existsSync(), isTrue);
    });

    test('Debug.xcconfig includes Pods configuration', () {
      final content = debugConfig.readAsStringSync();
      expect(content.contains('#include?'), isTrue);
      expect(content.contains('Pods-Runner.debug.xcconfig'), isTrue,
          reason: 'Should include CocoaPods debug configuration');
    });

    test('Release.xcconfig includes Pods configuration', () {
      final content = releaseConfig.readAsStringSync();
      expect(content.contains('#include?'), isTrue);
      expect(content.contains('Pods-Runner.release.xcconfig'), isTrue,
          reason: 'Should include CocoaPods release configuration');
    });

    test('Debug.xcconfig includes Generated.xcconfig', () {
      final content = debugConfig.readAsStringSync();
      expect(content.contains('#include "Generated.xcconfig"'), isTrue);
    });

    test('Release.xcconfig includes Generated.xcconfig', () {
      final content = releaseConfig.readAsStringSync();
      expect(content.contains('#include "Generated.xcconfig"'), isTrue);
    });

    test('Debug.xcconfig has correct include order', () {
      final lines = debugConfig.readAsLinesSync();
      final podsLineIndex = lines.indexWhere((l) => l.contains('Pods-Runner'));
      final generatedLineIndex = lines.indexWhere((l) => l.contains('Generated.xcconfig'));
      
      expect(podsLineIndex, lessThan(generatedLineIndex),
          reason: 'Pods config should be included before Generated config');
    });

    test('Release.xcconfig has correct include order', () {
      final lines = releaseConfig.readAsLinesSync();
      final podsLineIndex = lines.indexWhere((l) => l.contains('Pods-Runner'));
      final generatedLineIndex = lines.indexWhere((l) => l.contains('Generated.xcconfig'));
      
      expect(podsLineIndex, lessThan(generatedLineIndex),
          reason: 'Pods config should be included before Generated config');
    });

    test('xcconfig files use optional include', () {
      final debugContent = debugConfig.readAsStringSync();
      final releaseContent = releaseConfig.readAsStringSync();
      
      expect(debugContent.contains('#include?'), isTrue,
          reason: 'Should use optional include (#include?) for Pods');
      expect(releaseContent.contains('#include?'), isTrue,
          reason: 'Should use optional include (#include?) for Pods');
    });
  });
}