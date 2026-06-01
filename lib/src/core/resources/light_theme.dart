import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/constant/generated/fonts.gen.dart';
import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData themeData = ThemeData(
  fontFamily: FontFamily.rubik,
  scaffoldBackgroundColor: AppColors.baseBgPrimary,
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.textPrimary,
    onPrimary: AppColors.textPrimaryInverse,
    secondary: AppColors.textSecondary,
    onSecondary: AppColors.textSecondaryInverse,
    error: AppColors.error,
    onError: AppColors.errorLight,
    surface: AppColors.baseBgPrimary,
    onSurface: AppColors.baseBgPrimaryInverse,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.progressBar),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: AppColors.baseBgPrimary,
    surfaceTintColor: AppColors.baseBgPrimary,
    systemOverlayStyle: SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.baseBgPrimary,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: TextStyle(color: AppColors.textPrimary),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.baseBgPrimary,
    selectedIconTheme: IconThemeData(color: AppColors.iconAccent),
    unselectedIconTheme: IconThemeData(color: AppColors.iconDisabled),
    selectedItemColor: AppColors.textPrimary,
    unselectedItemColor: AppColors.textSecondary,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.textPrimary),
    displayMedium: TextStyle(color: AppColors.textPrimary),
    displaySmall: TextStyle(color: AppColors.textPrimary),
    headlineLarge: TextStyle(color: AppColors.textPrimary),
    headlineMedium: TextStyle(color: AppColors.textPrimary),
    headlineSmall: TextStyle(color: AppColors.textPrimary),
    titleLarge: TextStyle(color: AppColors.textPrimary),
    titleMedium: TextStyle(color: AppColors.textPrimary),
    titleSmall: TextStyle(color: AppColors.textPrimary),
    bodyLarge: TextStyle(color: AppColors.textPrimary),
    bodyMedium: TextStyle(color: AppColors.textPrimary),
    bodySmall: TextStyle(color: AppColors.textPrimary),
    labelLarge: TextStyle(color: AppColors.textPrimary),
    labelMedium: TextStyle(color: AppColors.textPrimary),
    labelSmall: TextStyle(color: AppColors.textPrimary),
  ),
  iconTheme: const IconThemeData(color: AppColors.iconPrimaryInverse),
  cardTheme: const CardThemeData(color: AppColors.baseBgPrimary, surfaceTintColor: AppColors.baseBgSecondary),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.buttonBgTertiary,
    disabledColor: AppColors.buttonBgTertiary,
    focusColor: AppColors.buttonBgSecondary,
    hoverColor: AppColors.buttonBgTertiary,
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(16)),
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: const WidgetStatePropertyAll(0),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.textDisabled;
        }
        return AppColors.textPrimaryInverse;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.buttonBgDisabled;
        }
        return Colors.transparent;
      }),
    ),
  ),
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
      foregroundColor: WidgetStatePropertyAll(AppColors.textPrimary),
      backgroundColor: WidgetStatePropertyAll(AppColors.buttonBgTertiary),
    ),
  ),
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: ZoomPageTransitionsBuilder(allowEnterRouteSnapshotting: false),
    },
  ),
  inputDecorationTheme: const InputDecorationTheme(
    alignLabelWithHint: true,
    isDense: true,
    outlineBorder: BorderSide.none,
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none, color: Colors.transparent),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: AppColors.baseBgPrimary),
  extensions: [
    IconsX(
      bag24Logo: Assets.svg.logoLight.path,
      bag24Icon: Assets.images.appIconLight.path,
      mileOnAirLogo: Assets.svg.mileOnAirLight.path,
    ),
    const ColorsX(
      baseBgPrimary: AppColors.baseBgPrimary,
      baseBgPrimaryInverse: AppColors.baseBgPrimaryInverse,
      baseBgSecondary: AppColors.baseBgSecondary,
      borderBrand: AppColors.borderBrand,
      borderPrimary: AppColors.borderPrimary,
      borderSecondary: AppColors.borderSecondary,
      iconDisabled: AppColors.iconDisabled,
      iconAccent: AppColors.iconAccent,
      iconPrimary: AppColors.iconPrimary,
      iconPrimaryInverse: AppColors.iconPrimaryInverse,
      iconSecondary: AppColors.iconSecondary,
      iconTertiary: AppColors.iconTertiary,
      badgeBgPrimary: AppColors.badgeBgPrimary,
      badgeBgSecondary: AppColors.badgeBgSecondary,
      badgeBorder: AppColors.badgeBorder,
      buttonBgDisabled: AppColors.buttonBgDisabled,
      buttonBgAlpha: AppColors.buttonBgAlpha,
      buttonBgSecondary: AppColors.buttonBgSecondary,
      buttonBgSecondaryInverse: AppColors.buttonBgSecondaryInverse,
      buttonBgTertiary: AppColors.buttonBgTertiary,
      cellBgPrimary: AppColors.cellBgPrimary,
      cellBgSecondary: AppColors.cellBgSecondary,
      cellBorderActive: AppColors.cellBorderActive,
      inputBgPrimary: AppColors.inputBgPrimary,
      inputBgSecondary: AppColors.inputBgSecondary,
      progressBar: AppColors.progressBar,
      trackBar: AppColors.trackBar,
      checkbox: AppColors.checkbox,
      checkboxBg: AppColors.checkboxBg,
      selectCheckbox: AppColors.selectCheckbox,
      bgSnackBar: AppColors.bgSnackBar,
      bgTooltip: AppColors.bgTooltip,
      tabBgPrimary: AppColors.tabBgPrimary,
      tabBgSecondary: AppColors.tabBgSecondary,
      toggleBgDisabled: AppColors.toggleBgDisabled,
      toggleBgSecondary: AppColors.toggleBgSecondary,
      toggleHandle: AppColors.toggleHandle,
      toggleHandleDisabled: AppColors.toggleHandleDisabled,
      togglePrimary: AppColors.togglePrimary,
      textDisabled: AppColors.textDisabled,
      textAccent: AppColors.textAccent,
      textPrimary: AppColors.textPrimary,
      textPrimaryInverse: AppColors.textPrimaryInverse,
      textSecondary: AppColors.textSecondary,
      textSecondaryInverse: AppColors.textSecondaryInverse,
      textTertiary: AppColors.textTertiary,
      error: AppColors.error,
      errorLight: AppColors.errorLight,
      info: AppColors.info,
      infoLight: AppColors.infoLight,
      success: AppColors.success,
      successLight: AppColors.successLight,
      warning: AppColors.warning,
      warningLight: AppColors.warningLight,
      flybag: AppColors.flybag,
      lostFound: AppColors.lostFound,
      mileOnAir: AppColors.mileOnAir,
      mileOnAirLight: AppColors.mileOnAirLight,
    ),
  ],
);
