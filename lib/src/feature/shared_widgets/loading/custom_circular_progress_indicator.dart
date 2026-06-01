import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/loading/gradient_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

/// LoadingSpinner is an alternate CircularProgressIndicator widget with a
/// gradient finish. It requires a [color] and the [diameter].
/// It uses an AnimatorController and spins indefinitely.
class const CustomLoadingSpinner({
  /// The main color of the gradient
  final Color? color,

  /// The diameter of the loading wheel
  final double diameter = 40,

  /// The strokeWidth of the loading wheel
  final double strokeWidth = 6,
  super.key,
}) extends StatefulWidget {
  @override
  CustomLoadingSpinnerState createState() => CustomLoadingSpinnerState();
}

class CustomLoadingSpinnerState() extends State<CustomLoadingSpinner> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    /// Starts the animation. Repeat makes sure it spins indefinitely.
    _controller = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Creates the spinning animation. Accepts the spin sprite
    return RotationTransition(
      /// The turns of the spin.
      /// ignore: prefer_int_literals
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
      child: GradientCircularProgressIndicator(
        /// The radius define the size of the circle
        radius: widget.diameter / 2,

        /// The list of the color gradient
        gradientColors: [
          (widget.color ?? context.colors.progressBar).withAlpha(0),
          widget.color ?? context.colors.progressBar,
        ],

        /// Thickness of the loading wheel
        strokeWidth: widget.strokeWidth,
      ),
    );
  }
}
