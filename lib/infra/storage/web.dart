import 'package:web/web.dart';
import 'interace.dart';

class WebStorageService implements StorageService {
  @override
  Future<void> save(String key, String value) async {
    window.localStorage.setItem(key, value);
  }

  @override
  Future<String?> load(String key) async {
    return window.localStorage.getItem(key);
  }

  @override
  Future<void> delete(String key) async {
    window.localStorage.removeItem(key);
  }
}

class StorageServiceFactory {
  static StorageService create() {
    return WebStorageService();
  }
}
