import 'dart:convert' show Converter;

import 'package:bag24/src/feature/payment/model/payment_model.dart';
import 'package:bag24/src/feature/payment/model/payment_status.dart';
import 'package:rest_client/order/dto/payment_data_dto.dart';

final class const PaymentModelDecoder() extends Converter<PaymentDataDto, PaymentModel> {
  @override
  PaymentModel convert(PaymentDataDto input) => PaymentModel(
    id: input.id,
    amount: input.amount,
    status: PaymentStatus.fromPaymentState(input.state),
    url: input.url,
    createdAt: input.createdAt,
  );
}
