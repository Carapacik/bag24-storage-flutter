import 'package:rest_client/order/dto/order_qr_dto.dart';

class const OrderQrModel({required final String qr, required final int ttl, required final int amountToPay}) {
  factory decode(OrderQrDto dto) => OrderQrModel(qr: dto.qr, ttl: dto.ttl, amountToPay: dto.amountToPay);
}
