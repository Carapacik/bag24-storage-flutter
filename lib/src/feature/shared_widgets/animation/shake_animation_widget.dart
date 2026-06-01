import 'dart:math' as math;

import 'package:flutter/material.dart';

class const ShakeAnimationWidget({
  required final Widget child,
  final Duration duration = const Duration(milliseconds: 600),
  final double deltaX = 20,
  final Curve curve = Curves.bounceOut,
  super.key,
}) extends StatefulWidget {
  @override
  State<ShakeAnimationWidget> createState() => ShakeAnimationWidgetState();
}

class ShakeAnimationWidgetState() extends State<ShakeAnimationWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.duration)..addListener(_updateAnimation);
  }

  void _updateAnimation() => setState(() {});

  void shake() => _animationController.forward(from: 0);

  @override
  void dispose() {
    _animationController
      ..removeListener(_updateAnimation)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(math.sin(_animationController.value * math.pi * 10) * 2, 0),
      child: widget.child,
    );
  }
}
