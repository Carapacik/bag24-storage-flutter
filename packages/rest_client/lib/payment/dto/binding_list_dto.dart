import 'package:json_annotation/json_annotation.dart';

part 'binding_list_dto.g.dart';

@JsonSerializable()
class const BindingListDto({required final List<BindingDto> bindings}) {
  factory fromJson(Map<String, Object?> json) => _$BindingListDtoFromJson(json);

  Map<String, Object?> toJson() => _$BindingListDtoToJson(this);
}

@JsonSerializable()
class const BindingDto({
  required final String id,
  required final String first6,
  required final String last4,
  required final String cardType,
}) {
  factory fromJson(Map<String, Object?> json) => _$BindingDtoFromJson(json);

  Map<String, Object?> toJson() => _$BindingDtoToJson(this);
}
