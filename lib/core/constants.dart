class ApiConstants {
  static const String baseUrl = "10.0.0.2:3000";
  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);
}

class AppConstants {
  static final List<String> systemAppPackages = [
    'com.android.',
    'com.google.android.',
    'com.samsung.',
    'com.miui.',
    'com.huawei.',
    'com.oppo.',
    'com.vivo.',
    'com.motorola.',
  ];
}
