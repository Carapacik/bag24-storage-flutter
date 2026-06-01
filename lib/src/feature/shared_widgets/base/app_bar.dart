import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const CustomAppBar({
  super.key,
  final Widget? title,
  final String? titleText,
  final Widget? leading,
  final double? leadingWidth,
  final List<Widget>? actions,
  final Color? backgroundColor,
  final VoidCallback? onLeadingPressed,
  final bool automaticallyImplyLeading = true,
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: windowSize.isCompact,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leadingWidth: leadingWidth,
      leading: leading ?? (automaticallyImplyLeading ? const Bag24BackButton() : null),
      actions: actions,
      title:
          title ?? (titleText != null ? Text(titleText!, style: context.textStyles.bodyEmphasized, maxLines: 2) : null),
    );
  }
}

class const Bag24BackButton({final VoidCallback? onPressed, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () async => await Navigator.of(context).maybePop(),
      icon: SvgPicture.asset(
        Assets.svg.arrowLeft.path,
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
      ),
    );
  }
}

class const Bag24CloseButton({final VoidCallback? onPressed, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () async => await Navigator.of(context).maybePop(),
      icon: SvgPicture.asset(
        Assets.svg.close.path,
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
      ),
    );
  }
}
