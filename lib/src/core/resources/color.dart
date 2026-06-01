import 'package:flutter/material.dart';

abstract final class AppColors() {
  // Base
  static const _black200 = Color(0x331B1E1B);
  static const _black400 = Color(0x661B1E1B);
  static const _black600 = Color(0x991B1E1B);
  static const _black700 = Color(0xB31B1E1B);
  static const _black900Solid = Color(0xFF0B0D0C);
  static const _blackMainSolid = Color(0xFF1B1E1B);
  static const _blue200 = Color(0x1A375DFB);
  static const _blueMainSolid = Color(0xFF375DFB);
  static const _green200 = Color(0x1A54DA81);
  static const _green300 = Color(0x3354DA81);
  static const _green700Solid = Color(0xFF22A84F);
  static const _greenMainSolid = Color(0xFF2AD162);
  static const _neutral50Solid = Color(0xFFF6F8F8);
  static const _neutral100Solid = Color(0xFFEEF1F1);
  static const _neutral200Solid = Color(0xFFE1E5E5);
  static const _neutral300Solid = Color(0xFFCFD1D1);
  static const _neutral400Solid = Color(0xFFA7AAA8);
  static const _neutral600Solid = Color(0xFF282B29);
  static const _orange200 = Color(0x1AF79009);
  static const _orangeMainSolid = Color(0xFFF79009);
  static const _pink100Solid = Color(0xFFFFECEF);
  static const _pink400Solid = Color(0xFFFF3D58);
  static const _pink600Solid = Color(0xFFED2A4D);
  static const _pink900Solid = Color(0xFF3D2324);
  static const _red200 = Color(0x1ADF1C41);
  static const _redMainSolid = Color(0xFFDF1C41);
  static const _violet600Solid = Color(0xFF644BF1);
  static const _white50 = Color(0x0DFFFFFF);
  static const _white100 = Color(0x1AFFFFFF);
  static const _white200 = Color(0x33FFFFFF);
  static const _white400 = Color(0x66FFFFFF);
  static const _white500 = Color(0x80FFFFFF);
  static const _white700 = Color(0xB3FFFFFF);
  static const _whiteMainSolid = Color(0xFFFFFFFF);

  // Light
  static const Color baseBgPrimary = _whiteMainSolid;
  static const Color baseBgPrimaryInverse = _blackMainSolid;
  static const Color baseBgSecondary = _neutral50Solid;

  static const Color borderBrand = _greenMainSolid;
  static const Color borderPrimary = _neutral200Solid;
  static const Color borderSecondary = _neutral100Solid;

  static const Color iconDisabled = _black200;
  static const Color iconAccent = _green700Solid;
  static const Color iconPrimary = _whiteMainSolid;
  static const Color iconPrimaryInverse = _blackMainSolid;
  static const Color iconSecondary = _neutral400Solid;
  static const Color iconTertiary = _neutral300Solid;

  static const Color badgeBgPrimary = _white400;
  static const Color badgeBgSecondary = _neutral100Solid;
  static const Color badgeBorder = _neutral100Solid;

  static const Color buttonBgDisabled = _neutral50Solid;
  static const Color buttonBgAlpha = _white400;
  static const Color buttonBgSecondary = _green200;
  static const Color buttonBgSecondaryInverse = _whiteMainSolid;
  static const Color buttonBgTertiary = _neutral100Solid;

  static const Color cellBgPrimary = _neutral100Solid;
  static const Color cellBgSecondary = _whiteMainSolid;
  static const Color cellBorderActive = _greenMainSolid;

  static const Color inputBgPrimary = _neutral100Solid;
  static const Color inputBgSecondary = _whiteMainSolid;

  static const Color progressBar = _greenMainSolid;
  static const Color trackBar = _neutral100Solid;

  static const Color checkbox = _greenMainSolid;
  static const Color checkboxBg = _whiteMainSolid;
  static const Color selectCheckbox = _neutral200Solid;

  static const Color bgSnackBar = _black600;
  static const Color bgTooltip = _black900Solid;

  static const Color tabBgPrimary = _whiteMainSolid;
  static const Color tabBgSecondary = _neutral100Solid;

  static const Color toggleBgDisabled = _neutral50Solid;
  static const Color toggleBgSecondary = _neutral200Solid;
  static const Color toggleHandle = _whiteMainSolid;
  static const Color toggleHandleDisabled = _whiteMainSolid;
  static const Color togglePrimary = _greenMainSolid;

  static const Color textDisabled = _black200;
  static const Color textAccent = _green700Solid;
  static const Color textPrimary = _blackMainSolid;
  static const Color textPrimaryInverse = _whiteMainSolid;
  static const Color textSecondary = _black700;
  static const Color textSecondaryInverse = _white700;
  static const Color textTertiary = _black400;

  // Semantic
  static const Color error = _redMainSolid;
  static const Color errorLight = _red200;
  static const Color info = _blueMainSolid;
  static const Color infoLight = _blue200;
  static const Color success = _green700Solid;
  static const Color successLight = _green300;
  static const Color warning = _orangeMainSolid;
  static const Color warningLight = _orange200;

  // Services
  static const Color flybag = _pink600Solid;
  static const Color lostFound = _violet600Solid;
  static const Color mileOnAir = _pink400Solid;
  static const Color mileOnAirLight = _pink100Solid;
  static const Color darkMileOnAirLight = _pink900Solid;

  // Dark
  static const Color darkBaseBgPrimary = _black900Solid;
  static const Color darkBaseBgPrimaryInverse = _whiteMainSolid;
  static const Color darkBaseBgSecondary = _blackMainSolid;

  static const Color darkBorderBrand = _greenMainSolid;
  static const Color darkBorderPrimary = _white100;
  static const Color darkBorderSecondary = _white50;

  static const Color darkIconDisabled = _black200;
  static const Color darkIconAccent = _greenMainSolid;
  static const Color darkIconPrimary = _blackMainSolid;
  static const Color darkIconPrimaryInverse = _whiteMainSolid;
  static const Color darkIconSecondary = _white700;
  static const Color darkIconTertiary = _white200;

  static const Color darkBadgeBgPrimary = _white100;
  static const Color darkBadgeBgSecondary = _white100;
  static const Color darkBadgeBorder = _neutral100Solid;

  static const Color darkButtonBgDisabled = _white50;
  static const Color darkButtonBgAlpha = _white400;
  static const Color darkButtonBgSecondary = _green300;
  static const Color darkButtonBgSecondaryInverse = _black900Solid;
  static const Color darkButtonBgTertiary = _white100;

  static const Color darkCellBgPrimary = _white100;
  static const Color darkCellBgSecondary = _white100;
  static const Color darkCellBorderActive = _greenMainSolid;

  static const Color darkInputBgPrimary = _white100;
  static const Color darkInputBgSecondary = _blackMainSolid;

  static const Color darkProgressBar = _greenMainSolid;
  static const Color darkTrackBar = _white200;

  static const Color darkCheckbox = _greenMainSolid;
  static const Color darkCheckboxBg = _white100;
  static const Color darkSelectCheckbox = _white100;

  static const Color darkBgSnackBar = _black600;
  static const Color darkBgTooltip = _neutral600Solid;

  static const Color darkTabBgPrimary = _blackMainSolid;
  static const Color darkTabBgSecondary = _white100;

  static const Color darkToggleBgDisabled = _white100;
  static const Color darkToggleBgSecondary = _white200;
  static const Color darkToggleHandle = _whiteMainSolid;
  static const Color darkToggleHandleDisabled = _white100;
  static const Color darkTogglePrimary = _whiteMainSolid;

  static const Color darkTextDisabled = _white200;
  static const Color darkTextAccent = _greenMainSolid;
  static const Color darkTextPrimary = _whiteMainSolid;
  static const Color darkTextPrimaryInverse = _whiteMainSolid;
  static const Color darkTextSecondary = _white700;
  static const Color darkTextSecondaryInverse = _black700;
  static const Color darkTextTertiary = _white500;

  static const List<Color> gradientBAG24 = [Color(0xFFC5FF3F), Color(0xFF2AD162)];

  static const List<Color> gradientMileOnAir = [Color(0xFF14145C), Color(0xFF68255B), Color(0xFFDE3D5A)];

  static const List<Color> gradientStorage = [Color(0xFFF3FFA7), Color(0xFFF4C727), Color(0xFFE0832D)];

  static const List<Color> gradientFlybag = [Color(0xFFED2A4D), Color(0xFFFFFFFF)];
}
