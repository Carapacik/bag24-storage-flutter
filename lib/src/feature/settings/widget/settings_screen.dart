import 'dart:async';
import 'dart:io';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/constant/localization/localization.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/authentication/widget/authentication_scope.dart';
import 'package:bag24/src/feature/biometrics/data/biometrics_repository.dart';
import 'package:bag24/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:bag24/src/feature/settings/model/app_settings.dart';
import 'package:bag24/src/feature/settings/model/app_theme.dart';
import 'package:bag24/src/feature/settings/widget/settings_scope.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/toggle_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class const SettingsScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: context.l10n.settings),
      backgroundColor: context.colors.baseBgSecondary,
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ThemeSection(),
          SizedBox(height: 8),
          _LanguageSection(),
          SizedBox(height: 8),
          Expanded(child: _SecuritySection()),
        ],
      ),
    );
  }
}

class const _ThemeSection() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppSettings appSettings = SettingsScope.settingsOf(context);
    final AppSettingsBloc bloc = SettingsScope.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.baseBgPrimary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.appTheme, style: context.textStyles.title3Emphasized),
              const SizedBox(height: 20),
              CustomToggleButtons(
                initialIndex: _initialIndex(appSettings.appTheme?.themeMode ?? ThemeMode.system),
                toggleItems: [
                  (
                    onTap: () => bloc.add(
                      AppSettingsEvent.updateAppSettings(
                        appSettings: appSettings.copyWith(appTheme: AppTheme.defaultTheme),
                      ),
                    ),
                    text: context.l10n.systemTheme,
                    suffixIcon: const Text('📱', style: TextStyle(fontSize: 18)),
                  ),
                  (
                    onTap: () => bloc.add(
                      AppSettingsEvent.updateAppSettings(
                        appSettings: appSettings.copyWith(appTheme: const AppTheme(themeMode: ThemeMode.light)),
                      ),
                    ),
                    text: context.l10n.lightTheme,
                    suffixIcon: const Text('☀️', style: TextStyle(fontSize: 18)),
                  ),
                  (
                    onTap: () => bloc.add(
                      AppSettingsEvent.updateAppSettings(
                        appSettings: appSettings.copyWith(appTheme: const AppTheme(themeMode: ThemeMode.dark)),
                      ),
                    ),
                    text: context.l10n.darkTheme,
                    suffixIcon: const Text('🌒', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _initialIndex(ThemeMode mode) => switch (mode) {
    ThemeMode.system => 0,
    ThemeMode.light => 1,
    ThemeMode.dark => 2,
  };
}

class const _LanguageSection() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Locale locale = SettingsScope.settingsOf(context).locale ?? Localization.computeDefaultLocale();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.baseBgPrimary,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.lang, style: context.textStyles.title3Emphasized),
            const SizedBox(height: 20),
            Material(
              color: context.colors.buttonBgTertiary,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () async => await context.pushNamed(Routes.selectLanguage.name),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(switch (locale.languageCode) {
                          'ru' => context.l10n.russian,
                          'en' => context.l10n.english,
                          _ => context.l10n.russian,
                        }, style: context.textStyles.bodyRegular),
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
            ),
          ],
        ),
      ),
    );
  }
}

class const _SecuritySection() extends StatefulWidget {
  @override
  State<_SecuritySection> createState() => _SecuritySectionState();
}

class _SecuritySectionState() extends State<_SecuritySection> {
  late final IBiometricsRepository _biometricsRepository = context.dependencies.biometricsRepository;
  bool _biometricValue = false;
  late final Future<({BiometricType? biometricType, bool biometricValue})> _future = _getBiometrics();

  @override
  void initState() {
    super.initState();
    unawaited(_getBiometrics());
  }

  Future<({BiometricType? biometricType, bool biometricValue})> _getBiometrics() async {
    final List<BiometricType> availableBiometrics = await LocalAuthentication().getAvailableBiometrics();
    BiometricType? biometricType;
    var biometricValue = false;
    if (availableBiometrics.contains(BiometricType.face) && Platform.isIOS) {
      biometricType = BiometricType.face;
      biometricValue = await _biometricsRepository.getFace();
    } else if (availableBiometrics.contains(BiometricType.fingerprint) && Platform.isIOS) {
      biometricType = BiometricType.fingerprint;
      biometricValue = await _biometricsRepository.getFingerprint();
    } else if (availableBiometrics.contains(BiometricType.strong) && Platform.isAndroid) {
      biometricType = BiometricType.strong;
      biometricValue = await _biometricsRepository.getStrong();
    }
    setState(() => _biometricValue = biometricValue);
    return (biometricType: biometricType, biometricValue: biometricValue);
  }

  Future<void> _changeBiometrics({required BiometricType? biometricType, required bool biometricValue}) async {
    if (biometricType case BiometricType.face) {
      await _biometricsRepository.setFace(face: biometricValue);
    } else if (biometricType case BiometricType.fingerprint) {
      await _biometricsRepository.setFingerprint(fingerprint: biometricValue);
    } else if (biometricType case BiometricType.strong) {
      await _biometricsRepository.setStrong(strong: biometricValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (AuthenticationScope.userOf(context).isNotAuthenticated) {
      return const SizedBox.shrink();
    }
    return FutureBuilder<({BiometricType? biometricType, bool biometricValue})>(
      future: _future,
      builder: (context, snapshot) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.baseBgPrimary,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.safety, style: context.textStyles.title3Emphasized),
                _ListTileWidget(
                  onTap: () async => await context.pushNamed(Routes.editPin.name),
                  title: context.l10n.entryCode,
                  subtitle: context.l10n.changeAppLoginCode,
                  iconPath: Assets.svg.key.path,
                ),
                if (snapshot.hasData && snapshot.requireData.biometricType != null)
                  _ListTileWidget(
                    onTap: () {
                      setState(() => _biometricValue = !_biometricValue);
                      unawaited(
                        _changeBiometrics(
                          biometricType: snapshot.requireData.biometricType,
                          biometricValue: _biometricValue,
                        ),
                      );
                    },
                    title: context.l10n.biometrics,
                    subtitle: context.l10n.biometricsLogin,
                    iconPath: snapshot.requireData.biometricType == BiometricType.face
                        ? Assets.svg.faceIdSmall.path
                        : Assets.svg.touchIdSmall.path,
                    trailing: CupertinoSwitch(
                      value: _biometricValue,
                      activeTrackColor: context.colors.iconAccent,
                      onChanged: (value) {
                        setState(() => _biometricValue = value);
                        unawaited(
                          _changeBiometrics(
                            biometricType: snapshot.requireData.biometricType,
                            biometricValue: _biometricValue,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class const _ListTileWidget({
  required final VoidCallback onTap,
  required final String title,
  required final String subtitle,
  required final String iconPath,
  final Widget? trailing,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      title: Text(title, style: context.textStyles.bodyRegular),
      subtitle: Text(
        subtitle,
        style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textSecondary),
      ),
      leading: SizedBox(
        height: 44,
        width: 44,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.buttonBgTertiary,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              height: 24,
              width: 24,
              colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
            ),
          ),
        ),
      ),
      trailing: trailing,
    );
  }
}
