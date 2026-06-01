import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/luggage_order/model/additional_service.dart';
import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';
import 'package:bag24/src/feature/shared_widgets/button/custom_tooltip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const RateCard({required final RateData? rate, final VoidCallback? onTap, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.buttonBgTertiary,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(rate?.title ?? context.l10n.selectRate, style: context.textStyles.bodyRegular),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    Assets.svg.arrowRight.path,
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                  ),
                ],
              ),
              if (rate?.sizeDescription != null) ...[
                const SizedBox(height: 8),
                Row(
                  spacing: 4,
                  children: [
                    SvgPicture.asset(
                      Assets.svg.luggage.path,
                      height: 18,
                      width: 18,
                      colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
                    ),
                    Text(
                      rate!.sizeDescription,
                      style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                    ),
                    CustomTooltip(text: context.l10n.inSumOf3dimensions),
                  ],
                ),
              ],
              if (rate?.additionalServices != null && rate!.additionalServices!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Дополнительные услуги:',
                  style: context.textStyles.footnoteRegular.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: rate!.additionalServices!.length,
                  itemBuilder: (context, index) {
                    final AdditionalService service = rate!.additionalServices![index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        '${index + 1}. ${service.name} — ${service.price ~/ 100} Р',
                        style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
