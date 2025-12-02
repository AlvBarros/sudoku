abstract class StorageService {
  Future<void> save(String key, String value);
  Future<String?> load(String key);
  Future<void> delete(String key);
}
