import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

enum EditPinType() {
  oldPin,
  newPin,
  repeatPin;

  String localizedText(BuildContext context) => switch (this) {
    EditPinType.oldPin => context.l10n.enterOldCode,
    EditPinType.newPin => context.l10n.enterNewPinCode,
    EditPinType.repeatPin => context.l10n.repeatPinCode,
  };
}
