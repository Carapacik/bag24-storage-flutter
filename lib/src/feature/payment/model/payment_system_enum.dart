import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

enum PaymentSystemEnum() {
  unknown,
  mir,
  visa,
  mastercard,
  jcb;

  String get imagePath => switch (this) {
    PaymentSystemEnum.mir => Assets.svg.mir.path,
    PaymentSystemEnum.visa => Assets.svg.visa.path,
    PaymentSystemEnum.mastercard => Assets.svg.mastercard.path,
    PaymentSystemEnum.jcb => Assets.svg.jcb.path,
    PaymentSystemEnum.unknown => Assets.svg.sbp.path,
  };

  String localizedText(BuildContext context, String last4) {
    final String name = switch (this) {
      PaymentSystemEnum.mir => context.l10n.mir,
      PaymentSystemEnum.visa => context.l10n.visa,
      PaymentSystemEnum.mastercard => context.l10n.mastercard,
      PaymentSystemEnum.jcb => context.l10n.jcb,
      PaymentSystemEnum.unknown => context.l10n.card,
    };
    return '$name ···· $last4';
  }

  static PaymentSystemEnum fromString(String value) => PaymentSystemEnum.values.firstWhere(
    (status) => status.name == value.toLowerCase(),
    orElse: () => PaymentSystemEnum.unknown,
  );
}
