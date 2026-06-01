import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:flutter/material.dart';

Future<bool?> showCustomAlertDialog({
  required BuildContext context,
  required String title,
  required String cancelText,
  required String actionText,
  String? content,
  Axis buttonDirection = Axis.horizontal,
  VoidCallback? action,
  Color? actionTextColor,
  Color? actionButtonColor,
}) => showDialog<bool?>(
  context: context,
  builder: (context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: windowSize.isCompact ? 16 : ((MediaQuery.sizeOf(context).width - compactMaxWidth) / 2 - 16),
      ),
      backgroundColor: context.colors.baseBgPrimary,
      surfaceTintColor: context.colors.baseBgPrimary,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: context.textStyles.title2Emphasized),
            if (content != null) ...[
              const SizedBox(height: 8),
              Text(content, style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textSecondary)),
            ],
            const SizedBox(height: 24),
            if (buttonDirection == Axis.horizontal)
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      color: context.colors.buttonBgTertiary,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        onTap: () => Navigator.of(context).pop(false),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Text(
                            cancelText,
                            style: context.textStyles.calloutRegular,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: actionButtonColor ?? context.colors.buttonBgTertiary,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        onTap: () {
                          action?.call();
                          Navigator.of(context).pop(true);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Text(
                            actionText,
                            style: context.textStyles.calloutRegular.copyWith(
                              color: actionTextColor ?? context.colors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Material(
                    color: context.colors.buttonBgTertiary,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      onTap: () => Navigator.of(context).pop(false),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(cancelText, style: context.textStyles.calloutRegular, textAlign: TextAlign.center),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Material(
                    color: actionButtonColor ?? context.colors.buttonBgTertiary,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      onTap: () {
                        action?.call();
                        Navigator.of(context).pop(true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(
                          actionText,
                          style: context.textStyles.calloutRegular.copyWith(
                            color: actionTextColor ?? context.colors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  },
);
