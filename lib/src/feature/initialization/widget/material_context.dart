import 'package:bag24/src/core/constant/localization/localization.dart';
import 'package:bag24/src/core/router/router_state_mixin.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/settings/model/app_settings.dart';
import 'package:bag24/src/feature/settings/model/app_theme.dart';
import 'package:bag24/src/feature/settings/widget/settings_scope.dart';
import 'package:bag24/src/feature/shared_widgets/common/internet_connection_overlay.dart';
import 'package:flutter/material.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class const MaterialContext({super.key}) extends StatefulWidget {
  /// {@macro material_context}
  this;

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState() extends State<MaterialContext> with WidgetsBindingObserver, RouterStateMixin {
  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final GlobalKey<State<StatefulWidget>> _globalKey = GlobalKey(debugLabel: 'MaterialContext');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppSettings settings = SettingsScope.settingsOf(context);

    final AppTheme theme = settings.appTheme ?? AppTheme.defaultTheme;

    final ThemeData lightTheme = theme.buildThemeData(Brightness.light);
    final ThemeData darkTheme = theme.buildThemeData(Brightness.dark);
    final ThemeMode themeMode = theme.themeMode;
    final Locale locale = settings.locale ?? Localization.computeDefaultLocale();

    return MaterialApp.router(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      onGenerateTitle: (context) => context.l10n.appTitle,
      routerConfig: router,
      builder: (context, child) => MediaQuery.withNoTextScaling(
        key: _globalKey,
        child: InternetConnectionOverlay(child: child!),
      ),
    );
  }
}
