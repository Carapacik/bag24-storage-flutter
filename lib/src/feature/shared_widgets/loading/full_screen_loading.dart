import 'dart:ui';

import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/loading/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class const FullScreenLoading({
  required final bool inProgress,
  required final Widget child,
  final String? text,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(child: child),
        Positioned.fill(
          child: AbsorbPointer(
            absorbing: inProgress,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: inProgress
                  ? ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const RepaintBoundary(child: CustomLoadingSpinner()),
                              if (text != null)
                                Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(text!, style: context.textStyles.subheadlineRegular),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}
