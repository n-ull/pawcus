import 'fake_box.dart';
import 'package:pawcus/core/services/cache/cache_client.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';

/// A fake cache service that uses an in-memory Map and does not depend on
/// Hive. This allows tests to run without external mocking libraries.
class FakeCacheService extends CacheService {
  final FakeCacheClient client;

  FakeCacheService(this.client) : super(client);
}

class FakeCacheClient extends CacheClient {
  final Map<String, dynamic> _store = {};

  FakeCacheClient() : super(FakeBox({}));

  @override
  Future<void> set(String key, dynamic value) async {
    _store[key] = value;
  }

  @override
  T? get<T>(String key, {T? defaultValue}) {
    if (!_store.containsKey(key)) return defaultValue;
    return _store[key] as T?;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }

  // Helper for tests
  bool containsKey(String key) => _store.containsKey(key);
}

// Note: we rely on the `FakeBox` located next to the mocks to satisfy the
// CacheClient constructor. The FakeCacheClient overrides the methods used by
// CacheService, so the underlying Box is not actually exercised.
