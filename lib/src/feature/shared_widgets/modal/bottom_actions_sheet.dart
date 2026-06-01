import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const CustomSheetAction({
  required final String title,
  required final String iconPath,
  required final VoidCallback? onTap,
  final Color? color,
});

Future<T?> showCustomModalBottomActionsSheet<T>({
  required BuildContext context,
  required String title,
  required List<CustomSheetAction> actions,
}) => showCustomModalBottomSheet<T>(
  context: context,
  padding: const EdgeInsets.symmetric(vertical: 16),
  builder: (context) => SafeArea(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: context.textStyles.title3Emphasized.copyWith(color: context.colors.textPrimary),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 32,
              width: 32,
              child: Material(
                color: context.colors.buttonBgTertiary,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, size: 16, color: context.colors.iconPrimaryInverse),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 16),
        for (final item in actions)
          ListTile(
            minVerticalPadding: 16,
            onTap: () async {
              await Navigator.of(context).maybePop(item);
              item.onTap?.call();
            },
            leading: SvgPicture.asset(
              item.iconPath,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(item.color ?? context.colors.iconSecondary, BlendMode.srcIn),
            ),
            title: Text(
              item.title,
              style: context.textStyles.bodyRegular.copyWith(color: item.color ?? context.colors.textPrimary),
            ),
          ),
      ],
    ),
  ),
);
