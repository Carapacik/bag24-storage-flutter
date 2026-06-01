import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:flutter/material.dart';

class const AboutAppScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(titleText: context.l10n.aboutBAG24),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(context.icons.bag24Icon, height: 72, width: 72),
                const SizedBox(height: 20),
                Text(
                  context.l10n.appVersion,
                  style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textTertiary),
                ),
                Text(context.dependencies.packageInfo.version, style: context.textStyles.subheadlineRegular),
              ],
            ),
          ),
          PinnedBottomWidget(
            child: CustomTonalButton(onPressed: () => Navigator.of(context).pop(), text: context.l10n.close),
          ),
        ],
      ),
    );
  }
}
