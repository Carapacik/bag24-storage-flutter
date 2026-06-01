import 'dart:io';

import 'package:bag24/src/core/constant/constants.dart';
import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class const UpdateAppScreen({required final String latestVersion, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double imageDimension = windowSize.maybeMap(compact: () => 160.0, orElse: () => 200.0);
    return Scaffold(
      appBar: CustomAppBar(
        title: SvgPicture.asset(context.icons.bag24Logo, width: 80),
        automaticallyImplyLeading: false,
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
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _VersionBadge(version: context.dependencies.packageInfo.version),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16, color: context.colors.iconSecondary),
                    const SizedBox(width: 4),
                    _VersionBadge(version: latestVersion),
                  ],
                ),
                const Spacer(flex: 2),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Assets.images.refresh.path, height: imageDimension, width: imageDimension),
                    const SizedBox(height: 20),
                    Text(
                      context.l10n.timeToUpdate,
                      style: context.textStyles.title2Emphasized,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      context.l10n.versionNoLongerSupportedDownloadLatest(latestVersion),
                      style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const Spacer(flex: 3),
                SizedBox(
                  width: double.infinity,
                  child: GradientElevatedButton(
                    onPressed: () async {
                      final Uri uri = !kIsWeb && Platform.isAndroid
                          ? Uri.parse(androidMarketUrl)
                          : Uri.parse(appleMarketUrl);
                      await launchUrl(uri);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(context.l10n.downloadTheUpdate),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          Assets.svg.import.path,
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

class const _VersionBadge({required final String version}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(color: context.colors.badgeBgSecondary, shape: const StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(version, style: context.textStyles.caption1Regular.copyWith(color: context.colors.textSecondary)),
      ),
    );
  }
}
