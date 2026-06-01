import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const CustomTooltip({required final String text, final bool isLeft = false, super.key}) extends StatefulWidget {
  @override
  State<CustomTooltip> createState() => _CustomTooltipState();
}

class _CustomTooltipState() extends State<CustomTooltip> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() => _visible = !_visible);
          },
          child: SvgPicture.asset(
            Assets.svg.question.path,
            height: 20,
            colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
          ),
        ),
        if (_visible)
          Positioned(
            bottom: 24,
            right: widget.isLeft ? 0 : null,
            child: DecoratedBox(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.colors.bgTooltip),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  widget.text,
                  style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textPrimaryInverse),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
