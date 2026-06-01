import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const InfoContainer({
  required final String title,
  required final String text,
  final bool isExpandedByHeight = false,
  final VoidCallback? onCloseTap,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.warningLight,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  Assets.svg.infoCircle.path,
                  height: 16,
                  width: 16,
                  colorFilter: ColorFilter.mode(context.colors.warning, BlendMode.srcIn),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    title,
                    style: context.textStyles.caption1Emphasized.copyWith(color: context.colors.warning),
                  ),
                ),
                if (onCloseTap != null) ...[
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: onCloseTap,
                    behavior: HitTestBehavior.opaque,
                    child: SvgPicture.asset(
                      Assets.svg.close.path,
                      width: 16,
                      height: 16,
                      colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                    ),
                  ),
                ],
              ],
            ),
            if (isExpandedByHeight) const Spacer() else const SizedBox(height: 8),
            Text(text, style: context.textStyles.caption1Regular.copyWith(color: context.colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
