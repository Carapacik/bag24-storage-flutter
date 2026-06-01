import 'package:dio/dio.dart';
import 'package:rest_client/result_response.dart';
import 'package:rest_client/storage/dto/storage_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'storage_client.g.dart';

@RestApi()
abstract class StorageClient {
  factory(Dio dio, {String? baseUrl}) = _StorageClient;

  /// Get Storages.
  ///
  /// Get Storages.
  ///
  /// [locationId] - Location ID.
  @GET('/v1/storages')
  Future<ResultResponse<StorageListDto>> getStorages({
    @Query('offset') required int offset,
    @Query('limit') int limit = 20,
    @Query('lat') double? lat,
    @Query('lon') double? lon,
    @Query('locationId') String? locationId,
    @Query('name') String? name,
  });

  /// Get Storage.
  ///
  /// Get Storages.
  ///
  /// [storageId] - Storage ID.
  @GET('/v1/storages/{storageId}')
  Future<ResultResponse<StorageDto>> getStorage({@Path('storageId') required String storageId});
}
