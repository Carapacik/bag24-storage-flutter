import 'package:meta/meta.dart';
import 'package:rest_client/order/dto/receipts_list_dto.dart';

@immutable
class const Receipt({
  required final String id,
  required final String url,
  required final int total,
  required final DateTime createdAt,
}) {
  factory decode(ReceiptDto input) =>
      Receipt(id: input.id, url: input.url, total: input.total, createdAt: input.createdAt);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Receipt &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          url == other.url &&
          total == other.total &&
          createdAt == other.createdAt;

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ total.hashCode ^ createdAt.hashCode;
}
