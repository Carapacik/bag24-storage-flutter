import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const MainNavigationBar({
  required final int selectedIndex,
  required final ValueChanged<int>? onDestinationSelected,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final svgColorFilter = ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn);
    final svgColorFilterSelected = ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcATop);

    final navBarItems = [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(Assets.svg.homeOutlined.path, height: 24, colorFilter: svgColorFilter),
        activeIcon: SvgPicture.asset(Assets.svg.homeFilled.path, height: 24, colorFilter: svgColorFilterSelected),
        label: context.l10n.home,
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(Assets.svg.noteOutlined.path, colorFilter: svgColorFilter),
        activeIcon: SvgPicture.asset(Assets.svg.noteFilled.path, colorFilter: svgColorFilterSelected),
        label: context.l10n.orders,
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(Assets.svg.profileOutlined.path, colorFilter: svgColorFilter),
        activeIcon: SvgPicture.asset(Assets.svg.profileFilled.path, colorFilter: svgColorFilterSelected),
        label: context.l10n.profile,
      ),
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SizedBox(
        height: 60 + MediaQuery.paddingOf(context).bottom,
        child: BottomNavigationBar(
          items: navBarItems,
          currentIndex: selectedIndex,
          showUnselectedLabels: true,
          selectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          onTap: onDestinationSelected,
        ),
      ),
    );
  }
}
