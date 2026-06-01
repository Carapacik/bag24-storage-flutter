import 'package:dio/dio.dart';
import 'package:rest_client/result_response.dart';
import 'package:rest_client/user/dto/miles_response_dto.dart';
import 'package:rest_client/user/dto/user_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'user_client.g.dart';

@RestApi()
abstract class UserClient {
  factory(Dio dio, {String? baseUrl}) = _UserClient;

  @GET('/v1/accounts/users/me')
  Future<ResultResponse<UserDto>> me();

  @DELETE('/v1/accounts/users/me')
  Future<void> deleteAccount();

  @PUT('/v1/accounts/users/me')
  Future<ResultResponse<UserRawDto>> update({
    @Field() required String firstName,
    @Field() required String lastName,
    @Field() required String phoneNumber,
  });

  @POST('/v1/accounts/users/me/register')
  Future<ResultResponse<UserDto>> register({
    @Field() String? firstName,
    @Field() String? lastName,
    @Field() String? middleName,
    @Field() String? sex,
    @Field() String? birthDate,
  });

  @POST('/v1/accounts/users/me/registerAgreements')
  Future<void> registerUserAgreements({
    @Field() required bool userAgreement,
    @Field() required bool privacyPolicy,
    @Field() required bool companyRules,
  });

  @POST('/v1/accounts/mileonair/register')
  Future<void> registerMoa();

  @GET('/v1/accounts/mileonair/miles')
  Future<ResultResponse<MilesResponseDto>> getMiles();
}
