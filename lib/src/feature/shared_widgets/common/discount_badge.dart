import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class const DiscountBadge({
  required final String discount,
  final List<Color> gradient = AppColors.gradientBAG24,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        gradient: LinearGradient(colors: gradient),
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(
          discount,
          style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textPrimaryInverse),
        ),
      ),
    );
  }
}
