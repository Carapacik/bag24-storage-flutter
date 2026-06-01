import 'package:bag24/src/core/constant/localization/localization.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:bag24/src/feature/settings/model/app_settings.dart';
import 'package:bag24/src/feature/settings/widget/settings_scope.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/round_checkbox.dart';
import 'package:flutter/material.dart';

class const SelectLanguageScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AppSettingsBloc bloc = SettingsScope.of(context);
    final AppSettings appSettings = SettingsScope.settingsOf(context);
    const supportedLocales = [Locale('ru'), Locale('en')];
    return Scaffold(
      appBar: CustomAppBar(titleText: context.l10n.lang),
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(16, 20, 16, 20 + MediaQuery.paddingOf(context).bottom),
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemCount: supportedLocales.length,
        itemBuilder: (context, index) => _LanguageItem(
          onTap: () => bloc.add(
            AppSettingsEvent.updateAppSettings(appSettings: appSettings.copyWith(locale: supportedLocales[index])),
          ),
          selected: appSettings.locale == supportedLocales[index],
          locale: supportedLocales[index],
        ),
      ),
    );
  }
}

class const _LanguageItem({
  required final VoidCallback onTap,
  required final bool selected,
  required final Locale locale,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Locale currentLocale = SettingsScope.settingsOf(context).locale ?? Localization.computeDefaultLocale();
    return Material(
      color: context.colors.buttonBgTertiary,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              SizedBox(
                height: 44,
                width: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: context.colors.baseBgPrimary,
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                  ),
                  child: Center(child: Text(locale.emoji, style: const TextStyle(fontSize: 24))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.localizedTitle(context, currentLocale),
                      style: context.textStyles.bodyRegular.copyWith(color: context.colors.textPrimary),
                    ),
                    Text(
                      locale.localizedTitle(context),
                      style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              RoundCheckbox(value: selected, onChanged: (_) => onTap.call()),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Locale {
  String get emoji => switch (this) {
    const Locale('ru') => '\uD83C\uDDF7\uD83C\uDDFA',
    const Locale('en') => '\uD83C\uDDEC\uD83C\uDDE7',
    _ => '',
  };

  String localizedTitle(BuildContext context, [Locale currentLocale = const Locale('en')]) {
    final ruTitle = {const Locale('ru'): 'Русский', const Locale('en'): 'Английский'};
    final enTitle = {const Locale('ru'): 'Russian', const Locale('en'): 'English'};
    return switch (currentLocale) {
      const Locale('ru') => ruTitle[this] ?? '',
      const Locale('en') => enTitle[this] ?? '',
      _ => '',
    };
  }
}
