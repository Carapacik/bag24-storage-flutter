import 'package:json_annotation/json_annotation.dart';

part 'upload_file_dto.g.dart';

@JsonSerializable()
class const UploadFileDto({
  /// Идентификатор загруженного файла
  required final String id,

  /// Url загруженного файла
  required final String url,

  /// Дата загрузки файла
  required final DateTime createdAt,
}) {
  factory fromJson(Map<String, Object?> json) => _$UploadFileDtoFromJson(json);

  Map<String, Object?> toJson() => _$UploadFileDtoToJson(this);
}
