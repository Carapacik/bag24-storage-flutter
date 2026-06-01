import 'package:bag24/src/core/constant/constants.dart';
import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class const SelectSendServiceScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<(Null Function(), String, String, String)> services = [
      (() {}, 'Отправить', 'Бумаги, документы и журналы', Assets.svg.sms.path),
      (() {}, 'Доставка', 'Заработайте от 500 ₽ за рейс', Assets.svg.airplane.path),
      (() {}, 'Получить', 'В постаматах более 11 аэропортов', Assets.svg.take.path),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: context.colors.baseBgSecondary,
      appBar: const CustomAppBar(backgroundColor: Colors.transparent),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          const _TopPart(),
          Positioned.fill(
            top: 200 + 20 + (MediaQuery.paddingOf(context).top - 56),
            child: Material(
              color: context.colors.baseBgPrimary,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              clipBehavior: Clip.antiAlias,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    children: [
                      ListView.separated(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: services.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final (Null Function(), String, String, String) service = services[index];
                          return _SelectServiceButton(
                            onTap: service.$1,
                            title: service.$2,
                            subtitle: service.$3,
                            iconPath: service.$4,
                          );
                        },
                      ),
                      const Spacer(),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Продолжая, вы соглашаетесь с ',
                              style: context.textStyles.caption1Regular.copyWith(color: context.colors.textTertiary),
                            ),
                            TextSpan(
                              text: 'условиями услуги отправления',
                              style: context.textStyles.caption1Regular.copyWith(color: context.colors.textPrimary),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async => await launchUrl(Uri.parse(mobilePrivacyPolicyUrl)),
                            ),
                            TextSpan(
                              text: ' и подтверждаете актуальность своих персональных данных',
                              style: context.textStyles.caption1Regular.copyWith(color: context.colors.textTertiary),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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

class const _TopPart() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SvgPicture.asset(
            Assets.svg.profilePattern.path,
            fit: BoxFit.cover,
            width: windowSize.isCompact ? MediaQuery.sizeOf(context).width : 400,
            colorFilter: ColorFilter.mode(context.colors.iconTertiary, BlendMode.srcIn),
          ),
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top - 56, // 56 = appbar height
          right: 0,
          left: 0,
          child: SizedBox(
            height: 200,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Отправка посылок', style: context.textStyles.title2Emphasized),
                          const SizedBox(height: 8),
                          Text(
                            'Быстрая доставка ваших отправлений',
                            style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(right: -24, child: Image.asset(Assets.images.flyPost.path, height: 200, width: 200)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class const _SelectServiceButton({
  required final VoidCallback onTap,
  required final String title,
  required final String subtitle,
  required final String iconPath,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.cellBgPrimary,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(iconPath, height: 28, width: 28),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: context.textStyles.bodyRegular),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textTertiary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SvgPicture.asset(
                Assets.svg.arrowRight.path,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(context.colors.iconTertiary, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
