import 'package:json_annotation/json_annotation.dart';

part 'receipts_list_dto.g.dart';

@JsonSerializable()
class const ReceiptsListDto({required final List<ReceiptDto> receipts}) {
  factory fromJson(Map<String, Object?> json) => _$ReceiptsListDtoFromJson(json);

  Map<String, Object?> toJson() => _$ReceiptsListDtoToJson(this);
}

@JsonSerializable()
class const ReceiptDto({
  /// Receipt ID
  required final String id,

  /// Receipt OFD url
  required final String url,

  /// Receipt total
  required final int total,

  /// Receipt created at
  required final DateTime createdAt,
}) {
  factory fromJson(Map<String, Object?> json) => _$ReceiptDtoFromJson(json);

  Map<String, Object?> toJson() => _$ReceiptDtoToJson(this);
}
