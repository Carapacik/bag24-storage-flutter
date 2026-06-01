import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

enum _ButtonVariant() {
  large,
  medium,
  compact,
}

class GradientElevatedButton extends StatelessWidget {
  const new({required this.onPressed, this.child, this.text, super.key})
    : assert((child != null) != (text != null), 'child or text must be provided'),
      _variant = _ButtonVariant.large;

  const new medium({required this.onPressed, this.child, this.text, super.key})
    : assert((child != null) != (text != null), 'child or text must be provided'),
      _variant = _ButtonVariant.medium;

  const new compact({required this.onPressed, this.child, this.text, super.key})
    : assert((child != null) != (text != null), 'child or text must be provided'),
      _variant = _ButtonVariant.compact;

  final _ButtonVariant _variant;
  final VoidCallback? onPressed;
  final Widget? child;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(switch (_variant) {
            _ButtonVariant.large || _ButtonVariant.medium => 16,
            _ButtonVariant.compact => 12,
          }),
        ),
        gradient: onPressed == null
            ? null
            : const LinearGradient(
                colors: AppColors.gradientBAG24,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          fixedSize: Size.fromHeight(switch (_variant) {
            _ButtonVariant.large => 56,
            _ButtonVariant.medium => 48,
            _ButtonVariant.compact => 40,
          }),
          textStyle: switch (_variant) {
            _ButtonVariant.large => context.textStyles.bodyRegular,
            _ButtonVariant.medium => context.textStyles.calloutRegular,
            _ButtonVariant.compact => context.textStyles.subheadlineRegular,
          },
        ),
        child: child ?? Text(text ?? ''),
      ),
    );
  }
}
