import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class const OrderStatusBadge({
  required final String text,
  required final Color textColor,
  required final Color color,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: color),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          children: [
            SizedBox(
              width: 6,
              height: 6,
              child: DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, color: textColor),
              ),
            ),
            const SizedBox(width: 6),
            Text(text, style: context.textStyles.caption1Regular.copyWith(color: textColor)),
          ],
        ),
      ),
    );
  }
}
