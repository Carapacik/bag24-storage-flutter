import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/luggage_order/model/rent_price.dart';
import 'package:bag24/src/feature/shared_widgets/button/round_checkbox.dart';
import 'package:bag24/src/feature/shared_widgets/common/discount_badge.dart';
import 'package:flutter/material.dart';

class const BaseLuggageRentWidget({
  required final String title,
  required final RentPrice rentPrice,
  final bool showCheckbox = false,
  final bool isSelected = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: context.textStyles.bodyRegular),
                const SizedBox(width: 8),
                if (rentPrice.basePrice != null && rentPrice.oldPrice != null)
                  DiscountBadge(discount: '${(rentPrice.basePrice ?? 0) - (rentPrice.oldPrice ?? 0)} ₽'),
              ],
            ),
            if (showCheckbox) IgnorePointer(child: RoundCheckbox(value: isSelected)),
          ],
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: WindowSizeScope.of(context).maybeMap(
            compact: () => [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${rentPrice.basePrice ?? rentPrice.initialPrice} ₽ ',
                      style: context.textStyles.bodyRegular.copyWith(
                        color: rentPrice.basePrice != null && rentPrice.days != null
                            ? context.colors.textPrimary
                            : context.colors.textSecondary,
                      ),
                    ),
                    if (rentPrice.basePrice != null && rentPrice.days != null)
                      TextSpan(
                        text: '${rentPrice.oldPrice} ₽',
                        style: context.textStyles.footnoteRegular.copyWith(
                          color: context.colors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    if (rentPrice.days != null)
                      TextSpan(text: ' ${context.l10n.forTheFirst} ${context.l10n.forDays(rentPrice.days!)}')
                    else
                      TextSpan(text: ' ${context.l10n.firstDay.toLowerCase()}'),
                  ],
                  style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${context.l10n.next} - ${rentPrice.prolongingPrice} ₽/${context.l10n.dayPeriod}',
                style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
              ),
            ],
            orElse: () => [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    rentPrice.days != null
                        ? '${context.l10n.first} ${context.l10n.forDays(rentPrice.days!)}'
                        : context.l10n.firstDay,
                    style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${rentPrice.basePrice ?? rentPrice.initialPrice} ₽ ',
                          style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textPrimary),
                        ),
                        if (rentPrice.basePrice != null && rentPrice.days != null)
                          TextSpan(
                            text: '${rentPrice.oldPrice} ₽',
                            style: context.textStyles.footnoteRegular.copyWith(
                              color: context.colors.textSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.subsequentDay,
                    style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                  ),
                  Text('${rentPrice.prolongingPrice} ₽ ', style: context.textStyles.footnoteRegular),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
