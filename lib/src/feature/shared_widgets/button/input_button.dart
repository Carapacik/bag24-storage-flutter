import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const CustomInputButton({
  required final VoidCallback onTap,
  required final String label,
  required final String? value,
  super.key,
}) extends StatefulWidget {
  @override
  State<CustomInputButton> createState() => _CustomInputButtonState();
}

class _CustomInputButtonState() extends State<CustomInputButton> {
  late final TextEditingController _controller = TextEditingController(text: widget.value ?? '');

  @override
  void didUpdateWidget(covariant CustomInputButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.value = TextEditingValue(text: widget.value ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      child: CustomTextField(
        controller: _controller,
        enabled: false,
        labelText: widget.label,
        maxLines: null,
        readOnly: true,
        suffixIcon: SvgPicture.asset(
          Assets.svg.arrowRight.path,
          height: 24,
          width: 24,
          colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
        ),
      ),
    );
  }
}
