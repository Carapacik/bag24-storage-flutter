import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

void showSuccessMessage(BuildContext context, String title, [String? description]) => _baseTopSnack(
  context,
  title: title,
  description: description,
  iconPath: Assets.svg.tickSquare.path,
  iconColor: context.colors.success,
);

void showInfoMessage(BuildContext context, String title, [String? description]) => _baseTopSnack(
  context,
  title: title,
  description: description,
  iconPath: Assets.svg.infoCircle.path,
  iconColor: context.colors.warning,
);

void showErrorMessage(BuildContext context, String title, [String? description]) => _baseTopSnack(
  context,
  title: title,
  description: description,
  iconPath: Assets.svg.closeSquare.path,
  iconColor: context.colors.error,
);

void showCustomAppException(BuildContext context, AppException exception, [String? customTitle]) => _baseTopSnack(
  context,
  title: exception.map(
    network: (e) => e.networkType?.localizedText(context) ?? context.l10n.unknownServerException,
    unknown: (e) => customTitle ?? exception.message,
  ),
  iconPath: Assets.svg.closeSquare.path,
  iconColor: context.colors.error,
);

void _baseTopSnack(
  BuildContext context, {
  required String title,
  required String iconPath,
  Color? iconColor,
  String? description,
}) {
  final WindowSize windowSize = WindowSizeScope.of(context);
  final double horizontalPadding = windowSize.isCompact
      ? 16.0
      : (MediaQuery.sizeOf(context).width - compactMaxWidth) / 2;
  return showTopSnackBar(
    Overlay.of(context),
    Material(
      color: context.colors.bgTooltip,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              iconPath,
              height: 20,
              width: 20,
              colorFilter: iconColor == null ? null : ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textStyles.calloutRegular.copyWith(color: context.colors.textPrimaryInverse),
                  ),
                  if (description != null)
                    Text(
                      description,
                      style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textPrimaryInverse),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 0),
  );
}
