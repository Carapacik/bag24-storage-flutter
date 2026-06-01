import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class const TechnicalErrorScreen({final bool knownError = false, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double imageDimension = windowSize.maybeMap(compact: () => 160.0, orElse: () => 200.0);
    return Scaffold(
      appBar: CustomAppBar(
        title: SvgPicture.asset(context.icons.bag24Logo, width: 80),
        automaticallyImplyLeading: knownError,
        backgroundColor: context.colors.baseBgSecondary,
      ),
      backgroundColor: context.colors.baseBgSecondary,
      body: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          color: context.colors.baseBgPrimary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.images.mechanic.path, height: imageDimension, width: imageDimension),
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.technicalProblems,
                      style: context.textStyles.title2Emphasized,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.weWillFixItSoon,
                      style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const Spacer(flex: 3),
                SizedBox(
                  width: double.infinity,
                  child: GradientElevatedButton(
                    onPressed: () => knownError ? context.pop() : context.goNamed(Routes.splash.name),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(knownError ? context.l10n.back : context.l10n.update),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          Assets.svg.update.path,
                          height: 24,
                          width: 24,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
