import 'package:pawcus/core/models/settings.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';

class SettingsService {
  final CacheService _cacheService;

  SettingsService(this._cacheService);

  Settings getSettings() {
    return _cacheService.getSettings();
  }

  Future<void> saveSettings(Settings settings) async {
    await _cacheService.saveSettings(settings);
  }
}
