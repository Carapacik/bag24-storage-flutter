import 'package:json_annotation/json_annotation.dart';

part 'banner_dto.g.dart';

@JsonSerializable()
class const BannerDto({
  required final String id,
  required final String photoUrl,
  final int position = 0,
  final String url = '',
  final String inAppPath = '',
}) {
  factory fromJson(Map<String, Object?> json) => _$BannerDtoFromJson(json);

  Map<String, Object?> toJson() => _$BannerDtoToJson(this);
}

@JsonSerializable()
class const BannerListDto({required final List<BannerDto> banners}) {
  factory fromJson(Map<String, Object?> json) => _$BannerListDtoFromJson(json);

  Map<String, Object?> toJson() => _$BannerListDtoToJson(this);
}
