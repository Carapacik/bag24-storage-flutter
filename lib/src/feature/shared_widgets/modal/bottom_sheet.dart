import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/modal/drag_handle.dart';
import 'package:flutter/material.dart';

Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
  EdgeInsets padding = EdgeInsets.zero,
  bool enableDrag = true,
  Color? backgroundColor,
  Color? dragBackgroundColor,
}) => showModalBottomSheet<T>(
  context: context,
  elevation: 0,
  backgroundColor: Colors.transparent,
  isScrollControlled: isScrollControlled,
  useRootNavigator: useRootNavigator,
  enableDrag: enableDrag,
  useSafeArea: true,
  builder: (context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Material(
        color: backgroundColor ?? context.colors.baseBgPrimary,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ColoredBox(
              color: dragBackgroundColor ?? context.colors.baseBgPrimary,
              child: const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: DragHandle()),
            ),
            Padding(padding: padding, child: builder.call(context)),
          ],
        ),
      ),
    ],
  ),
);
