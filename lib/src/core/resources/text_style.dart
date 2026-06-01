import 'package:flutter/widgets.dart';

abstract class AppTextStyle() {
  static const TextStyle tabletLargeTitleRegular = TextStyle(
    fontSize: 42,
    height: 1.05,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.2,
  );

  static const TextStyle tabletLargeTitleEmphasized = TextStyle(
    fontSize: 42,
    height: 1.05,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.2,
  );

  static const TextStyle tabletTitle1Regular = TextStyle(
    fontSize: 36,
    height: 1.11,
    fontWeight: FontWeight.w400,
    letterSpacing: -1,
  );

  static const TextStyle tabletTitle1Emphasized = TextStyle(
    fontSize: 36,
    height: 1.11,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
  );

  static const TextStyle tabletTitle2Regular = TextStyle(
    fontSize: 28,
    height: 1.14,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.8,
  );

  static const TextStyle tabletTitle2Emphasized = TextStyle(
    fontSize: 28,
    height: 1.14,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.8,
  );

  static const TextStyle tabletTitle3Regular = TextStyle(
    fontSize: 22,
    height: 1.09,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );

  static const TextStyle tabletTitle3Emphasized = TextStyle(
    fontSize: 22,
    height: 1.09,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const TextStyle tabletBodyMedium = TextStyle(
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const TextStyle tabletBodyEmphasized = TextStyle(
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.6,
  );

  static const TextStyle tabletBodyItalic = TextStyle(
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );

  static const TextStyle tabletBodyEmphasizedItalic = TextStyle(
    fontSize: 18,
    height: 1.33,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle tabletFootnoteRegular = TextStyle(
    fontSize: 14,
    height: 1.29,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );

  static const TextStyle tabletFootnoteEmphasized = TextStyle(
    fontSize: 14,
    height: 1.29,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const TextStyle tabletCaption1Regular = TextStyle(
    fontSize: 12,
    height: 1.17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  );

  static const TextStyle tabletCaption1Emphasized = TextStyle(
    fontSize: 12,
    height: 1.17,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4,
  );

  static const TextStyle mobileLargeTitleRegular = TextStyle(
    fontSize: 34,
    height: 1.18,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.2,
  );

  static const TextStyle mobileLargeTitleEmphasized = TextStyle(
    fontSize: 34,
    height: 1.06,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.3,
  );

  static const TextStyle mobileTitle1Regular = TextStyle(
    fontSize: 28,
    height: 1.14,
    fontWeight: FontWeight.w400,
    letterSpacing: -1,
  );

  static const TextStyle mobileTitle1Emphasized = TextStyle(
    fontSize: 28,
    height: 1.14,
    fontWeight: FontWeight.w600,
    letterSpacing: -1,
  );

  static const TextStyle mobileTitle2Regular = TextStyle(
    fontSize: 22,
    height: 1.27,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.8,
  );

  static const TextStyle mobileTitle2Emphasized = TextStyle(
    fontSize: 22,
    height: 1.27,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.8,
  );

  static const TextStyle mobileTitle3Regular = TextStyle(
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileTitle3Emphasized = TextStyle(
    fontSize: 20,
    height: 1.2,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileHeadlineRegular = TextStyle(
    fontSize: 17,
    height: 1.18,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileHeadlineItalic = TextStyle(
    fontSize: 17,
    height: 1.18,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileBodyRegular = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileBodyEmphasized = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileBodyItalic = TextStyle(
    fontSize: 16,
    height: 1.5,
    letterSpacing: -0.6,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileBodyEmphasizedItalic = TextStyle(
    fontSize: 16,
    height: 1.5,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileCalloutRegular = TextStyle(
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileCalloutEmphasized = TextStyle(
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileCalloutRegularItalic = TextStyle(
    fontSize: 16,
    height: 1.25,
    letterSpacing: -0.6,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileCalloutEmphasizedItalic = TextStyle(
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileSubheadlineRegular = TextStyle(
    fontSize: 14,
    height: 1.29,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileSubheadlineEmphasized = TextStyle(
    fontSize: 14,
    height: 1.29,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileSubheadlineRegular16 = TextStyle(
    fontSize: 14,
    height: 1.14,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileSubheadlineEmphasizedItalic = TextStyle(
    fontSize: 14,
    height: 1.29,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileFootnoteRegular = TextStyle(
    fontSize: 13,
    height: 1.23,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileFootnoteEmphasized = TextStyle(
    fontSize: 13,
    height: 1.23,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
  );

  static const TextStyle mobileFootnoteRegularItalic = TextStyle(
    fontSize: 13,
    height: 1.23,
    letterSpacing: -0.6,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileFootnoteEmphasizedItalic = TextStyle(
    fontSize: 13,
    height: 1.23,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.6,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileCaption1Regular = TextStyle(
    fontSize: 12,
    height: 1.17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  );

  static const TextStyle mobileCaption1Emphasized = TextStyle(
    fontSize: 12,
    height: 1.17,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4,
  );

  static const TextStyle mobileCaption1RegularItalic = TextStyle(
    fontSize: 12,
    height: 1.17,
    letterSpacing: -0.4,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileCaption1EmphasizedItalic = TextStyle(
    fontSize: 12,
    height: 1.17,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileCaption2Regular = TextStyle(
    fontSize: 11,
    height: 1.09,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.4,
  );

  static const TextStyle mobileCaption2Emphasized = TextStyle(
    fontSize: 11,
    height: 1.09,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4,
  );

  static const TextStyle mobileCaption2RegularItalic = TextStyle(
    fontSize: 11,
    height: 1.09,
    letterSpacing: -0.4,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle mobileCaption2EmphasizedItalic = TextStyle(
    fontSize: 11,
    height: 1.09,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4,
    fontStyle: FontStyle.italic,
  );
}
