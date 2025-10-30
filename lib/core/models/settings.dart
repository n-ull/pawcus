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