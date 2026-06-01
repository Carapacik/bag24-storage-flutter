import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:flutter/widgets.dart';

class TextStyleByWindowSize(final BuildContext context) {
  TextStyle get largeTitleEmphasized => WindowSizeScope.of(context).maybeMap(
    compact: () => AppTextStyle.mobileLargeTitleEmphasized,
    orElse: () => AppTextStyle.tabletLargeTitleEmphasized,
  );

  TextStyle get title1Emphasized => WindowSizeScope.of(context)
      .maybeMap(compact: () => AppTextStyle.mobileTitle1Emphasized, orElse: () => AppTextStyle.tabletTitle1Emphasized);

  TextStyle get title2Emphasized => WindowSizeScope.of(context)
      .maybeMap(compact: () => AppTextStyle.mobileTitle2Emphasized, orElse: () => AppTextStyle.tabletTitle2Emphasized);

  TextStyle get title3Emphasized => WindowSizeScope.of(context)
      .maybeMap(compact: () => AppTextStyle.mobileTitle3Emphasized, orElse: () => AppTextStyle.tabletTitle2Emphasized);

  TextStyle get bodyRegular =>
      WindowSizeScope.of(context)
          .maybeMap(compact: () => AppTextStyle.mobileBodyRegular, orElse: () => AppTextStyle.tabletBodyMedium);

  TextStyle get bodyEmphasized =>
      WindowSizeScope.of(context)
          .maybeMap(compact: () => AppTextStyle.mobileBodyEmphasized, orElse: () => AppTextStyle.tabletTitle3Regular);

  TextStyle get subheadlineRegular => WindowSizeScope.of(context)
      .maybeMap(compact: () => AppTextStyle.mobileSubheadlineRegular, orElse: () => AppTextStyle.mobileCalloutRegular);

  TextStyle get subheadlineRegular16 => WindowSizeScope.of(
    context,
  ).maybeMap(compact: () => AppTextStyle.mobileSubheadlineRegular16, orElse: () => AppTextStyle.tabletFootnoteRegular);

  TextStyle get subheadlineEmphasized => WindowSizeScope.of(context).maybeMap(
    compact: () => AppTextStyle.mobileSubheadlineEmphasized,
    orElse: () => AppTextStyle.mobileCalloutEmphasized,
  );

  TextStyle get calloutRegular =>
      WindowSizeScope.of(context)
          .maybeMap(compact: () => AppTextStyle.mobileCalloutRegular, orElse: () => AppTextStyle.tabletBodyMedium);

  TextStyle get calloutEmphasized => WindowSizeScope.of(context)
      .maybeMap(compact: () => AppTextStyle.mobileCalloutEmphasized, orElse: () => AppTextStyle.tabletBodyEmphasized);

  TextStyle get footnoteRegular => WindowSizeScope.of(context)
      .maybeMap(compact: () => AppTextStyle.mobileFootnoteRegular, orElse: () => AppTextStyle.tabletFootnoteRegular);

  TextStyle get caption1Regular => WindowSizeScope.of(context)
      .maybeMap(compact: () => AppTextStyle.mobileCaption1Regular, orElse: () => AppTextStyle.tabletFootnoteRegular);

  TextStyle get caption1Emphasized => WindowSizeScope.of(
    context,
  ).maybeMap(compact: () => AppTextStyle.mobileCaption1Emphasized, orElse: () => AppTextStyle.tabletFootnoteEmphasized);
}
