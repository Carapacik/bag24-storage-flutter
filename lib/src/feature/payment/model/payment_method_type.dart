import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:rest_client/order/dto/payment_method.dart';

enum PaymentMethodType {
  bankCard,
  binding,
  cash,
  miles,
  sbp,
  sberbank,
  mirpay;

  factory decode(PaymentMethodTypeDto type) =>
      PaymentMethodType.values.firstWhere((e) => e.name.toLowerCase() == type.name.toLowerCase());

  static PaymentMethodTypeDto encode(PaymentMethodType type) =>
      PaymentMethodTypeDto.values.firstWhere((e) => e.name.toLowerCase() == type.name.toLowerCase());

  String localizedText(BuildContext context) => switch (this) {
    PaymentMethodType.bankCard => context.l10n.bankCard,
    PaymentMethodType.sbp => context.l10n.fastPaymentSystem,
    PaymentMethodType.binding => context.l10n.bankCard,
    PaymentMethodType.sberbank => context.l10n.sberPay,
    PaymentMethodType.cash => context.l10n.cash,
    PaymentMethodType.miles => context.l10n.moaMiles,
    PaymentMethodType.mirpay => context.l10n.mirPay,
  };
}
