import 'package:dio/dio.dart';
import 'package:rest_client/account/dto/init_command.dart';
import 'package:rest_client/account/dto/token_dto.dart';
import 'package:rest_client/account/dto/verify_request_body_dto.dart';
import 'package:rest_client/result_response.dart';
import 'package:retrofit/retrofit.dart';

part 'account_client.g.dart';

@RestApi()
abstract class AccountClient {
  factory(Dio dio, {String? baseUrl}) = _AccountClient;

  @POST('/v1/accounts/auth/init')
  Future<void> initPhone({@Body() required InitCommand body});

  @POST('/v1/accounts/auth/verify')
  Future<ResultResponse<TokenDto>> verifyPhone(@Body() VerifyRequestBodyDto body);

  @POST('/v1/accounts/auth/me/logout')
  Future<void> logout();

  @POST('/v1/accounts/token/refresh')
  Future<HttpResponse<ResultResponse<TokenDto>>> refresh();
}
