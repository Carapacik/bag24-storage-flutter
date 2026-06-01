import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/button/custom_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const OrderPaymentsWidget({
  required final String title,
  required final int costOfLuggageStorage,
  required final int discount,
  required final int additionalPayment,
  required final int paidAmount,
  required final int additionalServicesTotal,
  required final int miles,
  required final bool useMiles,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool inProlongation = additionalPayment > 0;
    final divider = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: context.colors.borderSecondary, thickness: 1, height: 1),
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.baseBgPrimary,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.textStyles.title3Emphasized),
            const SizedBox(height: 16),
            // Хранение багажа
            if (!inProlongation) ...[
              _Item(title: context.l10n.luggageKeeping, text: '$costOfLuggageStorage ₽'),
              divider,
            ],
            // Стоимость за хранение
            if (paidAmount > 0 || inProlongation) ...[
              _Item(title: context.l10n.forStorage, text: '${inProlongation ? additionalPayment : paidAmount} ₽'),
              divider,
            ],
            // Доп. услуги
            if (additionalServicesTotal > 0) ...[
              _Item(title: 'Доп. услуги', text: '$additionalServicesTotal ₽'),
              divider,
            ],
            // Скидка
            if (discount != 0 && !inProlongation) ...[
              _Item(title: context.l10n.discount, text: '$discount ₽'),
              divider,
            ],
            // MILE ON AIR
            if (useMiles) ...[
              Row(
                children: [
                  SvgPicture.asset(context.icons.mileOnAirLogo, width: 80),
                  const SizedBox(width: 8),
                  CustomTooltip(text: '${context.l10n.minimumOrderAmount} 1 ₽'),
                  const Spacer(),
                  const SizedBox(width: 8),
                  Text('-$miles М', style: context.textStyles.bodyRegular.copyWith(color: context.colors.mileOnAir)),
                ],
              ),
              divider,
            ],
            // Итого
            _Item(
              primary: true,
              title: context.l10n.total,
              text: !inProlongation
                  ? '${costOfLuggageStorage + discount + paidAmount + additionalServicesTotal - miles} ₽'
                  : '${additionalPayment - miles} ₽',
            ),
            // Доплата
            if (additionalPayment != 0 && !inProlongation) ...[
              const SizedBox(height: 16),
              DecoratedBox(
                decoration: BoxDecoration(color: context.colors.warningLight, borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Assets.svg.infoCircle.path,
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(context.colors.warning, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.l10n.amountDue,
                        style: context.textStyles.bodyRegular.copyWith(color: context.colors.warning),
                      ),
                      const Spacer(),
                      Text(
                        '$additionalPayment ₽',
                        style: context.textStyles.bodyRegular.copyWith(color: context.colors.warning),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class const _Item({required final String title, required final String text, final bool primary = false})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: (primary ? context.textStyles.bodyEmphasized : context.textStyles.bodyRegular).copyWith(
              color: primary ? context.colors.textPrimary : context.colors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(text, style: primary ? context.textStyles.bodyEmphasized : context.textStyles.bodyRegular),
      ],
    );
  }
}
