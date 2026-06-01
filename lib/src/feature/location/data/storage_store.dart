class StorageStore._internal() {
  static final StorageStore _instance = StorageStore._internal();

  static StorageStore get instance => _instance;

  String? _currentStorageId;

  String? get currentStorageId => _currentStorageId;

  // ignore: avoid_setters_without_getters
  set storageId(String id) {
    _currentStorageId = id;
  }

  void resetId() {
    _currentStorageId = null;
  }
}
