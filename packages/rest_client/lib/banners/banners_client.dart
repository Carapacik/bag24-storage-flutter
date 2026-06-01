import 'package:dio/dio.dart';
import 'package:rest_client/banners/dto/banner_dto.dart';
import 'package:rest_client/result_response.dart';
import 'package:retrofit/retrofit.dart';

part 'banners_client.g.dart';

@RestApi()
abstract class BannersClient {
  factory(Dio dio, {String? baseUrl}) = _BannersClient;

  @GET('/v1/banners')
  Future<ResultResponse<BannerListDto>> getBanners();
}
