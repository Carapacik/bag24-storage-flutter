import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:flutter/material.dart';

class const RoundedRectangleContent({required final Widget child, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return Material(
      color: context.colors.baseBgPrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Padding(
        padding: windowSize.maybeMap(
          compact: () => const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          orElse: () => const EdgeInsets.all(32),
        ),
        child: child,
      ),
    );
  }
}
