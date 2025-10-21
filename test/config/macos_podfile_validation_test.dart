import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('macOS Podfile validation', () {
    late File podfile;
    late List<String> lines;

    setUpAll(() {
      podfile = File('macos/Podfile');
      if (podfile.existsSync()) {
        lines = podfile.readAsLinesSync();
      }
    });

    test('Podfile exists', () {
      expect(podfile.existsSync(), isTrue,
          reason: 'macOS Podfile should exist for CocoaPods integration');
    });

    test('specifies macOS platform version', () {
      final content = podfile.readAsStringSync();
      expect(content.contains("platform :osx, '10.15'"), isTrue,
          reason: 'Should specify minimum macOS version');
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
      expect(content.contains('def flutter_root'), isTrue);
    });

    test('flutter_root checks for Flutter-Generated.xcconfig in ephemeral', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('Flutter-Generated.xcconfig'), isTrue);
      expect(content.contains('ephemeral'), isTrue,
          reason: 'macOS uses ephemeral directory');
    });

    test('requires podhelper from flutter_tools', () {
      final content = podfile.readAsStringSync();
      expect(content.contains("require File.expand_path"), isTrue);
      expect(content.contains('podhelper'), isTrue);
    });

    test('calls flutter_macos_podfile_setup', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('flutter_macos_podfile_setup'), isTrue,
          reason: 'Required for Flutter macOS setup');
    });

    test('defines Runner target', () {
      final content = podfile.readAsStringSync();
      expect(content.contains("target 'Runner' do"), isTrue);
    });

    test('uses frameworks', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('use_frameworks!'), isTrue);
    });

    test('installs all macOS pods', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('flutter_install_all_macos_pods'), isTrue);
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

    test('applies Flutter additional macOS build settings', () {
      final content = podfile.readAsStringSync();
      expect(content.contains('flutter_additional_macos_build_settings'), isTrue);
    });

    test('has proper Ruby syntax structure', () {
      final content = podfile.readAsStringSync();
      final doCount = 'do'.allMatches(content).length;
      final endCount = 'end'.allMatches(content).length;
      expect(doCount, equals(endCount),
          reason: 'Ruby do/end blocks should be balanced');
    });

    test('file is properly formatted', () {
      final content = podfile.readAsStringSync();
      expect(content.endsWith('\n'), isTrue,
          reason: 'File should end with a newline');
    });
  });

  group('macOS xcconfig validation', () {
    late File debugConfig;
    late File releaseConfig;

    setUpAll(() {
      debugConfig = File('macos/Flutter/Flutter-Debug.xcconfig');
      releaseConfig = File('macos/Flutter/Flutter-Release.xcconfig');
    });

    test('Flutter-Debug.xcconfig exists', () {
      expect(debugConfig.existsSync(), isTrue);
    });

    test('Flutter-Release.xcconfig exists', () {
      expect(releaseConfig.existsSync(), isTrue);
    });

    test('Flutter-Debug.xcconfig includes Pods configuration', () {
      final content = debugConfig.readAsStringSync();
      expect(content.contains('#include?'), isTrue);
      expect(content.contains('Pods-Runner.debug.xcconfig'), isTrue);
    });

    test('Flutter-Release.xcconfig includes Pods configuration', () {
      final content = releaseConfig.readAsStringSync();
      expect(content.contains('#include?'), isTrue);
      expect(content.contains('Pods-Runner.release.xcconfig'), isTrue);
    });

    test('Flutter-Debug.xcconfig includes Flutter-Generated.xcconfig', () {
      final content = debugConfig.readAsStringSync();
      expect(content.contains('#include "ephemeral/Flutter-Generated.xcconfig"'), isTrue);
    });

    test('Flutter-Release.xcconfig includes Flutter-Generated.xcconfig', () {
      final content = releaseConfig.readAsStringSync();
      expect(content.contains('#include "ephemeral/Flutter-Generated.xcconfig"'), isTrue);
    });

    test('Flutter-Debug.xcconfig has correct include order', () {
      final lines = debugConfig.readAsLinesSync();
      final podsLineIndex = lines.indexWhere((l) => l.contains('Pods-Runner'));
      final generatedLineIndex = lines.indexWhere((l) => l.contains('Flutter-Generated.xcconfig'));
      
      expect(podsLineIndex, lessThan(generatedLineIndex),
          reason: 'Pods config should be included before Flutter-Generated config');
    });

    test('Flutter-Release.xcconfig has correct include order', () {
      final lines = releaseConfig.readAsLinesSync();
      final podsLineIndex = lines.indexWhere((l) => l.contains('Pods-Runner'));
      final generatedLineIndex = lines.indexWhere((l) => l.contains('Generated.xcconfig'));
      
      expect(podsLineIndex, lessThan(generatedLineIndex),
          reason: 'Pods config should be included before Flutter-Generated config');
    });
  });
}