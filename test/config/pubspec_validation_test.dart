import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart' as yaml;

void main() {
  group('pubspec.yaml validation', () {
    late File pubspecFile;
    late yaml.YamlMap pubspecContent;

    setUpAll(() {
      pubspecFile = File('pubspec.yaml');
      final content = pubspecFile.readAsStringSync();
      pubspecContent = yaml.loadYaml(content) as yaml.YamlMap;
    });

    test('pubspec.yaml file exists', () {
      expect(pubspecFile.existsSync(), isTrue);
    });

    test('has required top-level keys', () {
      expect(pubspecContent.containsKey('name'), isTrue);
      expect(pubspecContent.containsKey('description'), isTrue);
      expect(pubspecContent.containsKey('version'), isTrue);
      expect(pubspecContent.containsKey('environment'), isTrue);
      expect(pubspecContent.containsKey('dependencies'), isTrue);
      expect(pubspecContent.containsKey('dev_dependencies'), isTrue);
    });

    test('has valid project name', () {
      final name = pubspecContent['name'];
      expect(name, isNotNull);
      expect(name, equals('pawcus'));
      // Project name should follow Dart package naming conventions
      expect(name.toString(), matches(RegExp(r'^[a-z][a-z0-9_]*$')));
    });

    test('has valid version format', () {
      final version = pubspecContent['version'];
      expect(version, isNotNull);
      // Should follow semantic versioning: major.minor.patch+build
      expect(version.toString(), matches(RegExp(r'^\d+\.\d+\.\d+\+\d+$')));
    });

    test('has valid description', () {
      final description = pubspecContent['description'];
      expect(description, isNotNull);
      expect(description.toString().isNotEmpty, isTrue);
    });

    group('environment configuration', () {
      test('has SDK constraint', () {
        final environment = pubspecContent['environment'] as yaml.YamlMap;
        expect(environment.containsKey('sdk'), isTrue);
      });

      test('SDK constraint is valid', () {
        final environment = pubspecContent['environment'] as yaml.YamlMap;
        final sdk = environment['sdk'];
        expect(sdk, isNotNull);
        // Should be a valid version constraint
        expect(sdk.toString(), contains('^'));
      });
    });

    group('dependencies validation', () {
      late yaml.YamlMap dependencies;

      setUpAll(() {
        dependencies = pubspecContent['dependencies'] as yaml.YamlMap;
      });

      test('flutter SDK is included', () {
        expect(dependencies.containsKey('flutter'), isTrue);
        final flutter = dependencies['flutter'] as yaml.YamlMap;
        expect(flutter['sdk'], equals('flutter'));
      });

      test('app_usage dependency is present', () {
        expect(dependencies.containsKey('app_usage'), isTrue,
            reason: 'app_usage package should be added as a dependency');
      });

      test('app_usage has valid version', () {
        final appUsage = dependencies['app_usage'];
        expect(appUsage, isNotNull);
        expect(appUsage.toString(), matches(RegExp(r'^\^?\d+\.\d+\.\d+$')));
      });

      test('critical dependencies are present', () {
        final criticalDeps = [
          'cupertino_icons',
          'dio',
          'equatable',
          'bloc',
          'flutter_bloc',
          'get_it',
          'go_router_plus',
          'app_usage',
        ];

        for (final dep in criticalDeps) {
          expect(dependencies.containsKey(dep), isTrue,
              reason: '$dep should be present in dependencies');
        }
      });

      test('all dependencies have valid version constraints', () {
        dependencies.forEach((key, value) {
          if (value is String) {
            // Skip SDK dependencies
            if (value != 'flutter') {
              expect(
                value,
                matches(RegExp(r'^\^?\d+\.\d+\.\d+$')),
                reason: '$key should have a valid version constraint',
              );
            }
          }
        });
      });

      test('no dependency conflicts exist', () {
        // Ensure bloc and flutter_bloc versions are compatible
        final blocVersion = dependencies['bloc'].toString();
        final flutterBlocVersion = dependencies['flutter_bloc'].toString();
        
        expect(blocVersion, matches(RegExp(r'^\^?9\.')));
        expect(flutterBlocVersion, matches(RegExp(r'^\^?9\.')));
      });
    });

    group('dev_dependencies validation', () {
      late yaml.YamlMap devDependencies;

      setUpAll(() {
        devDependencies = pubspecContent['dev_dependencies'] as yaml.YamlMap;
      });

      test('flutter_test SDK is included', () {
        expect(devDependencies.containsKey('flutter_test'), isTrue);
        final flutterTest = devDependencies['flutter_test'] as yaml.YamlMap;
        expect(flutterTest['sdk'], equals('flutter'));
      });

      test('flutter_lints is included', () {
        expect(devDependencies.containsKey('flutter_lints'), isTrue);
      });

      test('flutter_lints has valid version', () {
        final flutterLints = devDependencies['flutter_lints'];
        expect(flutterLints, isNotNull);
        expect(flutterLints.toString(), matches(RegExp(r'^\^?\d+\.\d+\.\d+$')));
      });
    });

    group('flutter configuration', () {
      test('flutter section exists', () {
        expect(pubspecContent.containsKey('flutter'), isTrue);
      });

      test('uses-material-design is enabled', () {
        final flutter = pubspecContent['flutter'] as yaml.YamlMap;
        expect(flutter.containsKey('uses-material-design'), isTrue);
        expect(flutter['uses-material-design'], isTrue);
      });
    });

    group('publish configuration', () {
      test('is not publishable to pub.dev', () {
        final publishTo = pubspecContent['publish_to'];
        expect(publishTo, equals('none'),
            reason: 'Private packages should not be publishable');
      });
    });
  });

  group('pubspec.lock validation', () {
    late File lockFile;
    late yaml.YamlMap lockContent;

    setUpAll(() {
      lockFile = File('pubspec.lock');
      final content = lockFile.readAsStringSync();
      lockContent = yaml.loadYaml(content) as yaml.YamlMap;
    });

    test('pubspec.lock file exists', () {
      expect(lockFile.existsSync(), isTrue);
    });

    test('has packages key', () {
      expect(lockContent.containsKey('packages'), isTrue);
    });

    test('app_usage is locked in pubspec.lock', () {
      final packages = lockContent['packages'] as yaml.YamlMap;
      expect(packages.containsKey('app_usage'), isTrue,
          reason: 'app_usage should be present in pubspec.lock');
    });

    test('app_usage has correct structure', () {
      final packages = lockContent['packages'] as yaml.YamlMap;
      final appUsage = packages['app_usage'] as yaml.YamlMap;

      expect(appUsage.containsKey('dependency'), isTrue);
      expect(appUsage['dependency'], equals('direct main'));
      
      expect(appUsage.containsKey('description'), isTrue);
      final description = appUsage['description'] as yaml.YamlMap;
      expect(description['name'], equals('app_usage'));
      expect(description.containsKey('sha256'), isTrue);
      expect(description['url'], equals('https://pub.dev'));
      
      expect(appUsage.containsKey('source'), isTrue);
      expect(appUsage['source'], equals('hosted'));
      
      expect(appUsage.containsKey('version'), isTrue);
    });

    test('app_usage version matches expected version', () {
      final packages = lockContent['packages'] as yaml.YamlMap;
      final appUsage = packages['app_usage'] as yaml.YamlMap;
      final version = appUsage['version'].toString();
      
      expect(version, matches(RegExp(r'^4\.\d+\.\d+$')),
          reason: 'app_usage should be version 4.x.x');
    });

    test('all direct dependencies are locked', () {
      final packages = lockContent['packages'] as yaml.YamlMap;
      final expectedDeps = [
        'flutter',
        'cupertino_icons',
        'dio',
        'equatable',
        'bloc',
        'flutter_bloc',
        'get_it',
        'go_router_plus',
        'app_usage',
      ];

      for (final dep in expectedDeps) {
        expect(packages.containsKey(dep), isTrue,
            reason: '$dep should be locked in pubspec.lock');
      }
    });

    test('dependency integrity hashes are present', () {
      final packages = lockContent['packages'] as yaml.YamlMap;
      final appUsage = packages['app_usage'] as yaml.YamlMap;
      final description = appUsage['description'] as yaml.YamlMap;
      
      final sha256 = description['sha256'];
      expect(sha256, isNotNull);
      expect(sha256.toString().length, equals(64),
          reason: 'SHA256 hash should be 64 characters');
    });
  });
}