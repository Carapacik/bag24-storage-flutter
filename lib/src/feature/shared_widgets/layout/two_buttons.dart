import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:flutter/material.dart';

class const TwoButtons({required final Widget firstWidget, required final Widget secondWidget, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return windowSize.maybeMap(
      compact: () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: double.infinity, child: firstWidget),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: secondWidget),
        ],
      ),
      orElse: () => Row(
        children: [
          Expanded(child: firstWidget),
          const SizedBox(width: 16),
          Expanded(child: secondWidget),
        ],
      ),
    );
  }
}
