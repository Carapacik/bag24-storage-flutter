import 'dart:async';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/onboarding/bloc/onboarding_bloc.dart';
import 'package:bag24/src/feature/onboarding/model/onboarding_progress.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class const OnboardingScreen({super.key}) extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState() extends State<OnboardingScreen> with TickerProviderStateMixin {
  late final PageController _pageController = PageController();
  static const int _slidesLength = 3;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    unawaited(context.dependencies.analytics.onboardingTracker.trackOnboardingOpened());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _changeImage() async {
    if (_slidesLength - 1 == _currentIndex) {
      return await _goNext(context, OnboardingProgress.completed, withAuthorization: true);
    }

    setState(() => _currentIndex = (_currentIndex + 1) % _slidesLength);
    await _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _goNext(BuildContext context, OnboardingProgress progress, {bool withAuthorization = false}) async {
    context.read<OnboardingBloc>().add(const OnboardingEvent.setHideOnboarding());
    final GoRouter navigator = GoRouter.of(context);
    unawaited(context.dependencies.analytics.onboardingTracker.trackOnboardingFinished(progress));

    await navigator.pushNamed(withAuthorization ? Routes.signIn.name : Routes.home.name);
  }

  @override
  Widget build(BuildContext context) {
    final slides = <Slide>[
      Slide(
        image: Assets.images.onboarding1.path,
        title: context.l10n.onboardingLuggageStorageTitle,
        description: context.l10n.onboardingLuggageStorageDesc,
      ),
      Slide(
        image: Assets.images.onboarding2.path,
        title: context.l10n.onboardingLostItemsTitle,
        description: context.l10n.onboardingLostItemsDesc,
      ),
      Slide(
        image: Assets.images.onboarding3.path,
        title: context.l10n.onboardingLostFoundTitle,
        description: context.l10n.onboardingLostFoundDesc,
      ),
    ];
    final WindowSize windowSize = WindowSizeScope.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => Image.asset(slides[index].image, fit: BoxFit.cover),
          ),
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Center(
                child: SizedBox(
                  height: 4,
                  width: 120,
                  child: DecoratedBox(
                    decoration: const ShapeDecoration(shape: StadiumBorder()),
                    child: Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: 1,
                          heightFactor: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Colors.white24),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: (_currentIndex + 1) / slides.length,
                          heightFactor: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -8,
            right: 16,
            child: SafeArea(
              child: TextButton(
                onPressed: () async => await _goNext(context, OnboardingProgress.skipped),
                style: TextButton.styleFrom(fixedSize: const Size.fromHeight(0), padding: EdgeInsets.zero),
                child: Text(
                  context.l10n.skip,
                  style: context.textStyles.subheadlineRegular.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 320,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.baseBgPrimary,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(slides[_currentIndex].title, style: context.textStyles.largeTitleEmphasized),
                        windowSize.maybeMap(
                          compact: () => const SizedBox(height: 8),
                          orElse: () => const SizedBox(height: 16),
                        ),
                        Text(
                          slides[_currentIndex].description,
                          style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                        ),
                        const Spacer(),
                        windowSize.maybeMap(
                          compact: () => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (slides.length - 1 == _currentIndex) ...[
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomTonalButton(
                                    onPressed: () async => await _goNext(context, OnboardingProgress.completed),
                                    text: context.l10n.continueWithoutAuth,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: GradientElevatedButton(
                                  onPressed: _changeImage,
                                  text: slides.length - 1 == _currentIndex ? context.l10n.login : context.l10n.next,
                                ),
                              ),
                            ],
                          ),
                          orElse: () => Row(
                            children: [
                              if (slides.length - 1 == _currentIndex) ...[
                                Expanded(
                                  child: CustomTonalButton(
                                    onPressed: () async => await _goNext(context, OnboardingProgress.completed),
                                    text: context.l10n.continueWithoutAuth,
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                              Expanded(
                                child: GradientElevatedButton(
                                  onPressed: _changeImage,
                                  text: slides.length - 1 == _currentIndex ? context.l10n.login : context.l10n.next,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class const Slide({required final String image, required final String title, required final String description});
