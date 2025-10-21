import 'package:app_usage/app_usage.dart';
import 'package:pawcus/core/exceptions/app_usage_exceptions.dart';

class AppUsageService {
  Future<List<AppUsageInfo>> getAppsUsage(
    DateTime startPeriod,
    DateTime endPeriod,
  ) async {
    try {
      final apps = await AppUsage().getAppUsage(startPeriod, endPeriod);
      final filterApps = apps
          .where((app) => !isSystemApp(app.packageName))
          .toList();
      return filterApps;
    } catch (e) {
      throw GetAppUsageException(
        'Unexpected error retrieving app usage: ${e.toString()}',
      );
    }
  }

  bool isSystemApp(String packageName) {
    final systemPrefixes = [
      'com.android.',
      'com.google.android.',
      'com.samsung.',
      'com.miui.',
      'com.huawei.',
      'com.oppo.',
      'com.vivo.',
      'com.motorola.',
    ];

    return systemPrefixes.any((prefix) => packageName.startsWith(prefix));
  }
}
