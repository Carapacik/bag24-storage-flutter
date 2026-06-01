import 'package:flutter/material.dart';

class const PinnedBottomWidget({
  required final Widget child,
  final double bottom = 0,
  final bool isTransparentBg = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: bottom,
      right: 0,
      left: 0,
      child: Material(
        color: isTransparentBg ? Colors.transparent : null,
        child: SafeArea(
          top: false,
          child: Padding(padding: const EdgeInsets.all(16), child: child),
        ),
      ),
    );
  }
}
