import 'package:app_usage/app_usage.dart';
import 'package:pawcus/core/exceptions/app_usage_exceptions.dart';

class AppUsageService {
  static Future<List<AppUsageInfo>> getAppsUsage(
    DateTime startPeriod,
    DateTime endPeriod,
  ) async {
    try {
      return await AppUsage().getAppUsage(startPeriod, endPeriod);
    } catch (exception) {
      throw GetAppUsageException(
        'Something went wrong: ${exception.toString()}',
      );
    }
  }
}
