import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class const InstructionData(final String title, final String description) {
  static List<InstructionData> instructions(BuildContext context) => [
    InstructionData(context.l10n.faqHowPayOrder, context.l10n.faqHowPayOrderDescription),
    InstructionData(context.l10n.faqWhichRateChoose, context.l10n.faqWhichRateChooseDescription),
    InstructionData(context.l10n.faqHowManyItemsInOrder, context.l10n.faqHowManyItemsInOrderDescription),
    InstructionData(context.l10n.faqNoQRCode, context.l10n.faqNoQRCodeDescription),
    InstructionData(context.l10n.faqHowCancelOrder, context.l10n.faqHowCancelOrderDescription),
  ];
}
