import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/constant/generated/fonts.gen.dart';
import 'package:bag24/src/core/resources/color.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData themeData = ThemeData(
  fontFamily: FontFamily.rubik,
  scaffoldBackgroundColor: AppColors.darkBaseBgPrimary,
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.darkTextPrimary,
    onPrimary: AppColors.darkTextPrimaryInverse,
    secondary: AppColors.darkTextSecondary,
    onSecondary: AppColors.darkTextSecondaryInverse,
    error: AppColors.error,
    onError: AppColors.errorLight,
    surface: AppColors.darkBaseBgPrimary,
    onSurface: AppColors.darkBaseBgPrimaryInverse,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.darkProgressBar),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: AppColors.darkBaseBgPrimary,
    surfaceTintColor: AppColors.darkBaseBgPrimary,
    systemOverlayStyle: SystemUiOverlayStyle(
      systemNavigationBarColor: AppColors.darkBaseBgPrimary,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: TextStyle(color: AppColors.darkTextPrimary),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkBaseBgPrimary,
    selectedIconTheme: IconThemeData(color: AppColors.darkIconAccent),
    unselectedIconTheme: IconThemeData(color: AppColors.darkIconSecondary),
    selectedItemColor: AppColors.darkTextPrimary,
    unselectedItemColor: AppColors.darkTextSecondary,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.darkTextPrimary),
    displayMedium: TextStyle(color: AppColors.darkTextPrimary),
    displaySmall: TextStyle(color: AppColors.darkTextPrimary),
    headlineLarge: TextStyle(color: AppColors.darkTextPrimary),
    headlineMedium: TextStyle(color: AppColors.darkTextPrimary),
    headlineSmall: TextStyle(color: AppColors.darkTextPrimary),
    titleLarge: TextStyle(color: AppColors.darkTextPrimary),
    titleMedium: TextStyle(color: AppColors.darkTextPrimary),
    titleSmall: TextStyle(color: AppColors.darkTextPrimary),
    bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
    bodyMedium: TextStyle(color: AppColors.darkTextPrimary),
    bodySmall: TextStyle(color: AppColors.darkTextPrimary),
    labelLarge: TextStyle(color: AppColors.darkTextPrimary),
    labelMedium: TextStyle(color: AppColors.darkTextPrimary),
    labelSmall: TextStyle(color: AppColors.darkTextPrimary),
  ),
  iconTheme: const IconThemeData(color: AppColors.darkIconPrimaryInverse),
  cardTheme: const CardThemeData(color: AppColors.darkBaseBgPrimary, surfaceTintColor: AppColors.darkBaseBgSecondary),
  buttonTheme: const ButtonThemeData(
    buttonColor: AppColors.darkButtonBgTertiary,
    disabledColor: AppColors.darkButtonBgTertiary,
    focusColor: AppColors.darkButtonBgSecondary,
    hoverColor: AppColors.darkButtonBgTertiary,
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
      padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(16)),
      shape: const WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.darkTextDisabled;
        }
        return AppColors.darkTextPrimaryInverse;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return AppColors.darkButtonBgDisabled;
        }
        return Colors.transparent;
      }),
    ),
  ),
  filledButtonTheme: const FilledButtonThemeData(
    style: ButtonStyle(
      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))),
      foregroundColor: WidgetStatePropertyAll(AppColors.darkTextPrimary),
      backgroundColor: WidgetStatePropertyAll(AppColors.darkButtonBgTertiary),
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
  bottomSheetTheme: const BottomSheetThemeData(backgroundColor: AppColors.darkBaseBgPrimary),
  extensions: [
    IconsX(
      bag24Logo: Assets.svg.logoDark.path,
      bag24Icon: Assets.images.appIconDark.path,
      mileOnAirLogo: Assets.svg.mileOnAirDark.path,
    ),
    const ColorsX(
      baseBgPrimary: AppColors.darkBaseBgPrimary,
      baseBgPrimaryInverse: AppColors.darkBaseBgPrimaryInverse,
      baseBgSecondary: AppColors.darkBaseBgSecondary,
      borderBrand: AppColors.darkBorderBrand,
      borderPrimary: AppColors.darkBorderPrimary,
      borderSecondary: AppColors.darkBorderSecondary,
      iconDisabled: AppColors.darkIconDisabled,
      iconAccent: AppColors.darkIconAccent,
      iconPrimary: AppColors.darkIconPrimary,
      iconPrimaryInverse: AppColors.darkIconPrimaryInverse,
      iconSecondary: AppColors.darkIconSecondary,
      iconTertiary: AppColors.darkIconTertiary,
      badgeBgPrimary: AppColors.darkBadgeBgPrimary,
      badgeBgSecondary: AppColors.darkBadgeBgSecondary,
      badgeBorder: AppColors.darkBadgeBorder,
      buttonBgDisabled: AppColors.darkButtonBgDisabled,
      buttonBgAlpha: AppColors.darkButtonBgAlpha,
      buttonBgSecondary: AppColors.darkButtonBgSecondary,
      buttonBgSecondaryInverse: AppColors.darkButtonBgSecondaryInverse,
      buttonBgTertiary: AppColors.darkButtonBgTertiary,
      cellBgPrimary: AppColors.darkCellBgPrimary,
      cellBgSecondary: AppColors.darkCellBgSecondary,
      cellBorderActive: AppColors.darkCellBorderActive,
      inputBgPrimary: AppColors.darkInputBgPrimary,
      inputBgSecondary: AppColors.darkInputBgSecondary,
      progressBar: AppColors.darkProgressBar,
      trackBar: AppColors.darkTrackBar,
      checkbox: AppColors.darkCheckbox,
      checkboxBg: AppColors.darkCheckboxBg,
      selectCheckbox: AppColors.darkSelectCheckbox,
      bgSnackBar: AppColors.darkBgSnackBar,
      bgTooltip: AppColors.darkBgTooltip,
      tabBgPrimary: AppColors.darkTabBgPrimary,
      tabBgSecondary: AppColors.darkTabBgSecondary,
      toggleBgDisabled: AppColors.darkToggleBgDisabled,
      toggleBgSecondary: AppColors.darkToggleBgSecondary,
      toggleHandle: AppColors.darkToggleHandle,
      toggleHandleDisabled: AppColors.darkToggleHandleDisabled,
      togglePrimary: AppColors.darkTogglePrimary,
      textDisabled: AppColors.darkTextDisabled,
      textAccent: AppColors.darkTextAccent,
      textPrimary: AppColors.darkTextPrimary,
      textPrimaryInverse: AppColors.darkTextPrimaryInverse,
      textSecondary: AppColors.darkTextSecondary,
      textSecondaryInverse: AppColors.darkTextSecondaryInverse,
      textTertiary: AppColors.darkTextTertiary,
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
      mileOnAirLight: AppColors.darkMileOnAirLight,
    ),
  ],
);
