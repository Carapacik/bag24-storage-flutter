import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const CustomSearchBar({required final String hintText, final TextEditingController? controller, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      controller: controller,
      style: context.textStyles.bodyRegular,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        filled: true,
        fillColor: context.colors.inputBgPrimary,
        hintText: hintText,
        hintStyle: context.textStyles.bodyRegular.copyWith(color: context.colors.textTertiary),
        prefixIcon: SvgPicture.asset(
          Assets.svg.search.path,
          height: 20,
          width: 20,
          fit: BoxFit.none,
          colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
        ),
        suffixIcon: (controller?.text.isNotEmpty ?? false)
            ? IconButton(
                onPressed: () => controller?.clear(),
                visualDensity: VisualDensity.compact,
                splashRadius: 24,
                icon: SvgPicture.asset(
                  Assets.svg.closeCircle.path,
                  height: 20,
                  width: 20,
                  colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
                ),
              )
            : null,
      ),
    );
  }
}
