import 'package:bag24/src/core/constant/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// {@template localization}
/// Localization class which is used to localize app.
/// This class provides handy methods and tools.
/// {@endtemplate}
final class Localization._({
  /// Locale which is currently used.
  required final Locale locale,
}) extends AppLocalizations {
  /// {@macro localization}
  this;

  /// List of supported locales.
  static List<Locale> get supportedLocales => AppLocalizations.delegate.supportedLocales;

  static const AppLocalizationDelegate _delegate = AppLocalizations.delegate;

  /// List of localization delegates.
  static List<LocalizationsDelegate<void>> get localizationDelegates => [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    _delegate,
  ];

  /// {@macro localization}
  static Localization? get current => _current;

  /// {@macro localization}
  static Localization? _current;

  /// Computes the default locale.
  ///
  /// This is the locale that is used when no locale is specified.
  static Locale computeDefaultLocale() {
    final Locale locale = WidgetsBinding.instance.platformDispatcher.locale;

    if (_delegate.isSupported(locale)) {
      return locale;
    }

    return const Locale('ru');
  }

  /// Obtain [AppLocalizations] instance from [BuildContext].
  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations) ??
      (throw FlutterError('No AppLocalizations found in context'));
}
