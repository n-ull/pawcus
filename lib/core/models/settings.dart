import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rollbar_flutter_aio/common/rollbar_common.dart';


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
    return super.toString().split(".")[1].capitalize();
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

  final String logHandler;
  final Environment environment;
  final String rollbarAccessToken;
  final String rollbarCodeVersion;

  bool get useRollbar => logHandler == 'rollbar';

  const AppConfiguration({
    this.logHandler = _defaultLogHandler,
    this.environment = _defaultEnvironment,
    required this.rollbarAccessToken,
    this.rollbarCodeVersion = _defaultRollbarCodeVersion,
  });

  factory AppConfiguration.fromEnv() {
    final environment = dotenv.env['ENVIRONMENT'];
    return AppConfiguration(
      logHandler: dotenv.env['LOG_HANDLER'] ?? _defaultLogHandler,
      environment: environment != null ? Environment.fromString(environment) : _defaultEnvironment,
      rollbarAccessToken: dotenv.env['ROLLBAR_ACCESS_TOKEN']!,
      rollbarCodeVersion: dotenv.env['ROLLBAR_CODE_VERSION'] ?? _defaultRollbarCodeVersion,
    );
  }
}
