import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const IconWithDescriptionTile({
  required final String icon,
  required final String text,
  final TextAlign? textAlign,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: SvgPicture.asset(
              icon,
              height: 16,
              width: 16,
              colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
            ),
          ),
          TextSpan(
            text: ' $text',
            style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
