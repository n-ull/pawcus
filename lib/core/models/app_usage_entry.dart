class AppUsageEntry {
  final String packageName;
  /// usage in seconds during the requested period
  final int usageSeconds;

  AppUsageEntry({required this.packageName, required this.usageSeconds});
}
