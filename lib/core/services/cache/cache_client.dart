import 'package:hive/hive.dart';

class CacheClient {
  final Box _box;

  CacheClient(this._box);

  Future<void> set(String key, dynamic value) async {
    await _box.put(key, value);
  }

  dynamic get(String key) {
    return _box.get(key);
  }

  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  Future<void> clear() async {
    await _box.clear();
  }

  Future<void> close() async {
    await _box.close();
  }
}
