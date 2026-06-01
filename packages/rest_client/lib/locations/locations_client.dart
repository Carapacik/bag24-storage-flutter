import 'package:dio/dio.dart';
import 'package:rest_client/locations/dto/location_dto.dart';
import 'package:rest_client/result_response.dart';
import 'package:retrofit/retrofit.dart';

part 'locations_client.g.dart';

@RestApi()
abstract class LocationsClient {
  factory(Dio dio, {String? baseUrl}) = _LocationsClient;

  /// Get Locations.
  ///
  /// Returns available locations.
  @GET('/v1/locations')
  Future<ResultResponse<LocationListDto>> getLocations({
    @Query('location_ids') List<String>? locationIds,
    @Query('tags') List<String>? tags,
    @Query('lon') double? lon,
    @Query('lat') double? lat,
    @Query('search') String? search,
  });
}
