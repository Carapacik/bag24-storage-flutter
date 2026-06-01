import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class const CustomNavigationBar({required final Widget child, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: const [BoxShadow(color: Color(0x0911111A), offset: Offset(0, -6), blurRadius: 32)],
        color: context.colors.baseBgPrimary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SafeArea(top: false, child: child),
      ),
    );
  }
}
