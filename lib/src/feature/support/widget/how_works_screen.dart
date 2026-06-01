import 'dart:async';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/custom_painter/top_gradient_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class const HowWorksScreen({super.key}) extends StatefulWidget {
  @override
  State<HowWorksScreen> createState() => _HowWorksScreenState();
}

class _HowWorksScreenState() extends State<HowWorksScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late final PageController _pageController = PageController();
  late final List<(String, String, String)> _slides = [
    (context.l10n.howAppWorks1Title, context.l10n.howAppWorks1Description, Assets.images.howWorks1.path),
    (context.l10n.howAppWorks2Title, context.l10n.howAppWorks2Description, Assets.images.howWorks2.path),
    (context.l10n.howAppWorks3Title, context.l10n.howAppWorks3Description, Assets.images.howWorks3.path),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (_slides.length - 1 == _currentIndex) {
      return;
    }
    await _pageController.animateToPage(
      _currentIndex + 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _previousPage() async {
    if (0 == _currentIndex) {
      return;
    }
    await _pageController.animateToPage(
      _currentIndex - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(size: size, painter: TopGradientPainter()),
          SafeArea(child: _PageIndicator(index: _currentIndex)),
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) => Stack(
              children: [
                SafeArea(
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 70),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            _slides[index].$1,
                            style: context.textStyles.title1Emphasized,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            _slides[index].$2,
                            style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 0,
                  child: Image.asset(
                    _slides[index].$3,
                    height: MediaQuery.sizeOf(context).height * 0.54,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 160,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () async => await _previousPage(),
                          behavior: HitTestBehavior.opaque,
                          child: const SizedBox.expand(),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async => await _nextPage(),
                          behavior: HitTestBehavior.opaque,
                          child: const SizedBox.expand(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 16,
            top: MediaQuery.paddingOf(context).top + 36,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Material(
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                color: context.colors.buttonBgSecondaryInverse,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    Assets.svg.close.path,
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
          if (_currentIndex == 2)
            Positioned(
              bottom: 24,
              right: 16,
              left: 16,
              child: SafeArea(
                top: false,
                child: GradientElevatedButton(
                  onPressed: () {
                    unawaited(context.dependencies.analytics.luggageStorageTracker.trackLuggageStorageOpened());
                    context.pushReplacementNamed(Routes.selectStorage.name);
                  },
                  text: context.l10n.checkInYourLuggage,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class const _PageIndicator({required final int index}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            _Indicator(isActive: index >= 0),
            const SizedBox(width: 4),
            _Indicator(isActive: index >= 1),
            const SizedBox(width: 4),
            _Indicator(isActive: index >= 2),
          ],
        ),
      ),
    );
  }
}

class const _Indicator({final bool isActive = false}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 4,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isActive ? context.colors.iconPrimaryInverse : context.colors.iconTertiary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
