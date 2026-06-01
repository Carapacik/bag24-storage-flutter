import 'dart:io';

import 'package:bag24/src/core/constant/constants.dart';
import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/authentication/widget/authentication_scope.dart';
import 'package:bag24/src/feature/home/bloc/banners/banners_bloc.dart';
import 'package:bag24/src/feature/location/data/storage_store.dart';
import 'package:bag24/src/feature/location/model/storage_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class const BannersWidget({super.key}) extends StatefulWidget {
  @override
  State<BannersWidget> createState() => _BannersWidgetState();
}

class _BannersWidgetState() extends State<BannersWidget> {
  late final PageController _controller;
  late final bool _isUpdateAvailable = context.dependencies.appStateRepository.isUpdateAvailable;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _controller = PageController(viewportFraction: 315 / MediaQuery.sizeOf(context).width);
        _isControllerInitialized = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isControllerInitialized) {
      return const SizedBox.shrink();
    }

    return BlocBuilder<BannersBloc, BannersState>(
      builder: (context, state) {
        final List<StatelessWidget> banners = [
          if (_isUpdateAvailable) const _UpdateAvailableBanner(),
          if (state.nearestStorage != null) _BookBanner(storage: state.nearestStorage!),
          for (final banner in state.banners)
            _ImageBanner(
              imageUrl: banner.photoUrl,
              onTap: () async {
                final GoRouter navigator = GoRouter.of(context);
                if (banner.url.isNotEmpty && !await launchUrl(Uri.parse(banner.url))) {
                  await navigator.pushNamed(Routes.technicalError.name, queryParameters: {'knownError': 'true'});
                  return;
                }
                if (banner.inAppPath.isNotEmpty) {
                  await navigator.push(banner.inAppPath);
                  return;
                }
              },
            ),
        ];
        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 140),
              child: PageView.builder(
                controller: _controller,
                padEnds: false,
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 16, right: index == banners.length - 1 ? 16 : 0),
                    child: banners[index],
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            if (banners.length > 1)
              SmoothPageIndicator(
                controller: _controller,
                count: banners.length,
                effect: ScrollingDotsEffect(
                  dotHeight: 6,
                  dotWidth: 6,
                  dotColor: context.colors.iconTertiary,
                  activeDotColor: context.colors.baseBgPrimaryInverse,
                ),
              )
            else
              const SizedBox(height: 6),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}

class const _UpdateAvailableBanner() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.gradientBAG24,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 140, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    context.l10n.updateToLatestVersionOfApp,
                    style: context.textStyles.subheadlineEmphasized.copyWith(color: context.colors.textPrimaryInverse),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final Uri uri = !kIsWeb && Platform.isAndroid
                          ? Uri.parse(androidMarketUrl)
                          : Uri.parse(appleMarketUrl);
                      await launchUrl(uri);
                    },
                    child: SizedBox(
                      height: 32,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.colors.buttonBgSecondaryInverse,
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                          child: Center(
                            child: Text(
                              context.l10n.update,
                              style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textAccent),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(bottom: 0, right: 0, child: Image.asset(Assets.images.update.path, height: 140, width: 140)),
          ],
        ),
      ),
    );
  }
}

class const _BookBanner({required final Storage storage}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: GestureDetector(
        onTap: () async {
          if (AuthenticationScope.userOf(context, listen: false).isAuthenticated) {
            await context.pushNamed(Routes.checkInLuggageOrder.name, pathParameters: {'storageId': storage.id});
          } else {
            StorageStore.instance.storageId = storage.id;
            await context.pushNamed(Routes.signIn.name);
          }
        },
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: AppColors.gradientBAG24),
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: SvgPicture.asset(Assets.svg.bookLine.path, fit: BoxFit.fitWidth),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: Column(
                  children: [
                    FittedBox(
                      child: Text(
                        context.l10n.bookLuggageStorage,
                        style: context.textStyles.subheadlineEmphasized.copyWith(
                          color: context.colors.textPrimaryInverse,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      storage.fullName,
                      style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondaryInverse),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    const Spacer(),
                    DecoratedBox(
                      decoration: ShapeDecoration(
                        color: context.colors.buttonBgSecondaryInverse,
                        shape: const StadiumBorder(),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                        child: Text(
                          context.l10n.toBook,
                          style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _ImageBanner({required final VoidCallback onTap, final String? imageUrl}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget image;
    if (imageUrl != null) {
      image = CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        errorWidget: (context, url, error) => const SizedBox.expand(
          child: Material(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
            child: Center(child: Icon(Icons.error)),
          ),
        ),
      );
    } else {
      image = const SizedBox.shrink();
    }
    return SizedBox(
      height: 140,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(16)), child: image),
      ),
    );
  }
}
