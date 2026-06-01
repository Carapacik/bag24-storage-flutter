import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class const RoundCheckbox({required final bool value, final ValueChanged<bool?>? onChanged, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Material(
        shape: const CircleBorder(),
        color: value ? context.colors.progressBar : context.colors.selectCheckbox,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onChanged?.call(!value),
          child: value ? Center(child: Icon(Icons.check, color: context.colors.iconPrimary, size: 16)) : null,
        ),
      ),
    );
  }
}
