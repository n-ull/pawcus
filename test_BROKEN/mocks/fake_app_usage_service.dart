import 'package:pawcus/core/models/app_usage_entry.dart';
import 'package:pawcus/core/services/app_usage_service.dart';

class FakeAppUsageService extends AppUsageService {
  final List<AppUsageEntry> entries;

  FakeAppUsageService(this.entries);

  @override
  Future<List<AppUsageEntry>> getAppsUsage(DateTime startPeriod, DateTime endPeriod) async {
    return entries;
  }
}
