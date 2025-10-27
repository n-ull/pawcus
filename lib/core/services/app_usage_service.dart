import 'package:app_usage/app_usage.dart';
import 'package:pawcus/core/constants.dart';
import 'package:pawcus/core/exceptions/app_usage_exceptions.dart';
import 'package:pawcus/core/models/app_usage_entry.dart';

class AppUsageService {
  Future<List<AppUsageEntry>> getAppsUsage(
    DateTime startPeriod,
    DateTime endPeriod,
  ) async {
    try {
      final apps = await AppUsage().getAppUsage(startPeriod, endPeriod);

      // Convert package AppUsageInfo to our domain model AppUsageEntry.
      final entries = apps
          .where((app) => !isSystemApp(app.packageName))
          .map((app) {
        // Use dynamic access for the usage field because different versions
        // of the app_usage package may expose different property names.
        final usageMs = (app as dynamic).usage ?? 0;
        final usageSeconds = (usageMs is int) ? (usageMs ~/ 1000) : 0;
        return AppUsageEntry(
          packageName: app.packageName,
          usageSeconds: usageSeconds,
        );
      }).toList();

      return entries;
    } catch (e) {
      throw GetAppUsageException(
        'Unexpected error retrieving app usage: ${e.toString()}',
      );
    }
  }

  bool isSystemApp(String packageName) {
    final systemPrefixes = AppConstants.systemAppPackages;

    return systemPrefixes.any((prefix) => packageName.startsWith(prefix));
  }
}
