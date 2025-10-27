import 'package:pawcus/core/services/cache/cache_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A fake cache service that uses an in-memory Map and does not depend on
/// Hive. This allows tests to run without external mocking libraries.
class FakeCacheService extends CacheService {
  final FakeCacheClient client;

  FakeCacheService(this.client) : super(client as SharedPreferences);
}

class FakeCacheClient {
  final Map<String, dynamic> _store = {};

  FakeCacheClient() : super();

  Future<void> set(String key, dynamic value) async {
    _store[key] = value;
  }

  T? get<T>(String key, {T? defaultValue}) {
    if (!_store.containsKey(key)) return defaultValue;
    return _store[key] as T?;
  }

  Future<void> delete(String key) async {
    _store.remove(key);
  }

  Future<void> clear() async {
    _store.clear();
  }

  // Helper for tests
  bool containsKey(String key) => _store.containsKey(key);
}

// Note: we rely on the `FakeBox` located next to the mocks to satisfy the
// CacheClient constructor. The FakeCacheClient overrides the methods used by
// CacheService, so the underlying Box is not actually exercised.
