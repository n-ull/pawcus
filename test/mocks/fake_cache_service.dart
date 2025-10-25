import 'package:pawcus/core/services/cache/cache_client.dart';
import 'package:pawcus/core/services/cache/cache_service.dart';

class FakeCacheService extends CacheService {
  FakeCacheClient client;

  FakeCacheService(this.client) : super(client);
  
}

class FakeCacheClient extends CacheClient {
  FakeCacheClient(super.box);
}
