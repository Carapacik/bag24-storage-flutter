import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/animation/animated_horizontal_toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef ToggleItem = ({String text, Widget suffixIcon, VoidCallback onTap});

class const CustomToggleButtons({
  required final List<ToggleItem> toggleItems,
  required final int initialIndex,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedHorizontalToggle(
      taps: toggleItems.map((e) => e.text).toList(),
      suffixIcons: toggleItems.map((e) => e.suffixIcon).toList(),
      onChange: (_, targetIndex) => {toggleItems[targetIndex].onTap()},
      width: MediaQuery.sizeOf(context).width - 20 * 2,
      initialIndex: initialIndex,
      height: 56,
      duration: const Duration(milliseconds: 50),
      activeVerticalPadding: 4,
      activeHorizontalPadding: 4,
      background: context.colors.tabBgSecondary,
      activeColor: context.colors.tabBgPrimary,
      activeTextStyle: context.textStyles.calloutRegular.copyWith(color: context.colors.textPrimary),
      inActiveTextStyle: context.textStyles.calloutRegular.copyWith(color: context.colors.textSecondary),
      spaceBetweenIconAndText: 2,
      horizontalPadding: 0,
    );
  }
}
