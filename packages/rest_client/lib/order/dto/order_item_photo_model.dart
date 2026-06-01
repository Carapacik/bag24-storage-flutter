import 'package:json_annotation/json_annotation.dart';

part 'order_item_photo_model.g.dart';

@JsonSerializable()
class const OrderItemPhotoModel({
  /// Photo ID
  required final String id,

  /// Order item photo URL
  final String? photoUrl,
}) {
  factory fromJson(Map<String, Object?> json) => _$OrderItemPhotoModelFromJson(json);

  Map<String, Object?> toJson() => _$OrderItemPhotoModelToJson(this);
}
