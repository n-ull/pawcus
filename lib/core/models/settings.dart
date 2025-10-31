import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart' as logging;


enum Environment {
  production,
  development,
  test;

  static Environment fromString(String? value) {
    return switch (value) {
      'production' => Environment.production,
      'development' => Environment.development,
      'test' => Environment.test,
      _ => throw "Unsupported environment $value",
    };
  }

  @override
  String toString() {
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }
}


class Settings {
  bool notificationsEnabled = false;
  bool deepFocusEnabled = false;
  double appUsageThreshold = 10;

  Settings({
    required this.notificationsEnabled,
    required this.deepFocusEnabled,
    required this.appUsageThreshold,
  });
}


class AppConfiguration {
  static const _defaultLogHandler = 'printer';
  static const _defaultEnvironment = Environment.development;
  static const _defaultRollbarCodeVersion = '0.1.0';
  static const _defaultLogLevel = logging.Level.ALL;

  final String logHandler;
  final Environment environment;
  final String? rollbarAccessToken;
  final String rollbarCodeVersion;
  final logging.Level logLevel;

  bool get useRollbar => logHandler == 'rollbar' && (rollbarAccessToken?.isNotEmpty ?? false);

  const AppConfiguration({
    this.logHandler = _defaultLogHandler,
    this.environment = _defaultEnvironment,
    this.rollbarAccessToken,
    this.rollbarCodeVersion = _defaultRollbarCodeVersion,
    this.logLevel = _defaultLogLevel,
  });

  factory AppConfiguration.fromEnv() {
    final environment = dotenv.env['ENVIRONMENT'];
    final logLevel = dotenv.env['LOG_LEVEL'];
    final handler = dotenv.env['LOG_HANDLER'] ?? _defaultLogHandler;
    final token = dotenv.env['ROLLBAR_ACCESS_TOKEN'];

    if (handler == 'rollbar' && (token == null || token.isEmpty)) {
      throw ArgumentError('ROLLBAR_ACCESS_TOKEN is required when LOG_HANDLER=rollbar');
    }

    return AppConfiguration(
      logHandler: handler,
      environment: environment != null ? Environment.fromString(environment) : _defaultEnvironment,
      rollbarAccessToken: handler == 'rollbar' ? token : null,
      rollbarCodeVersion: dotenv.env['ROLLBAR_CODE_VERSION'] ?? _defaultRollbarCodeVersion,
      logLevel: logLevel != null ? _mapLogLevel(logLevel) : _defaultLogLevel,
    );
  }

  static logging.Level _mapLogLevel(String logLevel) {
    return switch (logLevel) {
      'ALL' => logging.Level.ALL,
      'FINEST' => logging.Level.FINEST,
      'FINER' => logging.Level.FINER,
      'FINE' => logging.Level.FINE,
      'CONFIG' => logging.Level.CONFIG,
      'INFO' => logging.Level.INFO,
      'WARNING' => logging.Level.WARNING,
      'SEVERE' => logging.Level.SEVERE,
      'SHOUT' => logging.Level.SHOUT,
      'OFF' => logging.Level.OFF,
      // Default to INFO
      _ => logging.Level.INFO,
    };
  }
}
