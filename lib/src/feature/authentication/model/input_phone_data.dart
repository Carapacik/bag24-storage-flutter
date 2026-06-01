import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/regex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:rest_client/account/dto/init_type.dart';

enum SignInType() {
  sms,
  telegram;

  static InitType encode(SignInType type) => InitType.values.firstWhere((e) => e.name == type.name);

  static bool isTelegram(SignInType type) => type == telegram;
}

class const InputPhoneData({
  required final String phone,
  required final String countryNumber,
  required final String countryCode,
  required final SignInType signInType,
}) {
  String? isValidPhone(BuildContext context) {
    if (phone.isEmpty) {
      return context.l10n.blankPhone;
    }
    if (countryCode.isEmpty || countryNumber.isEmpty) {
      return context.l10n.incorrentCountryCode;
    }
    if (!isPhoneValid(fullPhone, defaultCountryCode: countryCode)) {
      return context.l10n.incorrentPhoneNumber;
    }

    return null;
  }

  String get fullPhone => '+$countryNumber $phone'.replaceAll(AppRegExp.clearPhoneRegex, '');
}
