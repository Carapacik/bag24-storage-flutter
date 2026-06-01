import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rest_client/file_storage/dto/upload_file_dto.dart';
import 'package:rest_client/result_response.dart';
import 'package:retrofit/retrofit.dart';

part 'file_storage_client.g.dart';

@RestApi()
abstract class FileStorageClient {
  factory(Dio dio, {String? baseUrl}) = _FileStorageClient;

  /// Upload File.
  ///
  /// Upload File.
  ///
  /// [file] - Контент файла.
  @POST('/v1/fileStorage/files/')
  Future<ResultResponse<UploadFileDto>> uploadFile({@Part() required File file});
}
