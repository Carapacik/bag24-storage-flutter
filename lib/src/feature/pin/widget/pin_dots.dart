import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class const PinDots({required final String pin, final bool? isValid, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => PinDot(
          color: isValid == null
              ? pin.length >= index + 1
                    ? context.colors.iconPrimaryInverse
                    : context.colors.iconTertiary
              : (isValid ?? false)
              ? context.colors.success
              : context.colors.error,
        ),
      ),
    );
  }
}

class const PinDot({required final Color color, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: 12,
        height: 12,
        child: DecoratedBox(
          decoration: ShapeDecoration(shape: const CircleBorder(), color: color),
        ),
      ),
    );
  }
}
