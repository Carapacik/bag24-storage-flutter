import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class const DragHandle({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 4,
        width: 40,
        child: DecoratedBox(
          decoration: ShapeDecoration(color: context.colors.toggleBgSecondary, shape: const StadiumBorder()),
        ),
      ),
    );
  }
}
