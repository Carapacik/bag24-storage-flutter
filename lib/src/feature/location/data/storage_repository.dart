import 'package:bag24/src/feature/location/model/storage_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rest_client/storage/storage_client.dart';

abstract interface class IStorageRepository() {
  Future<List<Storage>> getStorages({int offset = 0, int limit = 20, Position? position, String? searchQuery});

  Future<Storage> getStorageById(String storageId);
}

class const StorageRepository({required final StorageClient _storageClient}) implements IStorageRepository {
  @override
  Future<List<Storage>> getStorages({int offset = 0, int limit = 20, Position? position, String? searchQuery}) async =>
      await _storageClient
          .getStorages(
            offset: offset,
            limit: limit,
            lat: position?.latitude,
            lon: position?.longitude,
            name: searchQuery,
          )
          .then((dto) => dto.result.storages.map(Storage.decode).toList());

  @override
  Future<Storage> getStorageById(String storageId) async =>
      await _storageClient.getStorage(storageId: storageId).then((dto) => Storage.decode(dto.result));
}
