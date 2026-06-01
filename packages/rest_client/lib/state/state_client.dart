// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:rest_client/result_response.dart';
import 'package:rest_client/state/dto/get_state_response.dart';
import 'package:retrofit/retrofit.dart';

part 'state_client.g.dart';

@RestApi()
abstract class StateClient {
  factory StateClient(Dio dio, {String? baseUrl}) = _StateClient;

  /// Get State.
  ///
  /// Получение состояний сервиса.
  @GET('/v1/state')
  Future<ResultResponse<GetStateResponse>> getState();
}
