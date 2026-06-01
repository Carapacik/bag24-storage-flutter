import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const PinKeyboard({
  required final String pin,
  required final ValueChanged<String> onChanged,
  required final VoidCallback onDeletePressed,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NumberKey(value: '1', onChanged: onChanged),
            const SizedBox(width: 24),
            NumberKey(value: '2', onChanged: onChanged),
            const SizedBox(width: 24),
            NumberKey(value: '3', onChanged: onChanged),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NumberKey(value: '4', onChanged: onChanged),
            const SizedBox(width: 24),
            NumberKey(value: '5', onChanged: onChanged),
            const SizedBox(width: 24),
            NumberKey(value: '6', onChanged: onChanged),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NumberKey(value: '7', onChanged: onChanged),
            const SizedBox(width: 24),
            NumberKey(value: '8', onChanged: onChanged),
            const SizedBox(width: 24),
            NumberKey(value: '9', onChanged: onChanged),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: windowSize.maybeMap(compact: () => 72, orElse: () => 90),
            ),
            const SizedBox(width: 24),
            NumberKey(value: '0', onChanged: onChanged),
            const SizedBox(width: 24),
            SizedBox.square(
              dimension: windowSize.maybeMap(compact: () => 72, orElse: () => 90),
              child: ElevatedButton(
                onPressed: onDeletePressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  alignment: Alignment.center,
                  shape: const CircleBorder(),
                ),
                child: SvgPicture.asset(
                  Assets.svg.backspace.path,
                  height: 32,
                  width: 32,
                  colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class const NumberKey({required final String value, required final ValueChanged<String> onChanged, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return SizedBox.square(
      dimension: windowSize.maybeMap(compact: () => 72, orElse: () => 90),
      child: ElevatedButton(
        onPressed: () => onChanged.call(value),
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colors.buttonBgTertiary,
          alignment: Alignment.center,
          shape: const CircleBorder(),
        ),
        child: Text(value, style: context.textStyles.largeTitleEmphasized.copyWith(color: context.colors.textPrimary)),
      ),
    );
  }
}
