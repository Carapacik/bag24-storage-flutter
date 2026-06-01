import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:bag24/src/feature/support/model/instruction_data.dart';
import 'package:flutter/material.dart';

class const InstructionsScreen({required final InstructionData instruction, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.paddingOf(context).bottom + 90),
            children: [
              Text(instruction.title, style: context.textStyles.title1Emphasized),
              const SizedBox(height: 16),
              Text(
                instruction.description,
                style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
              ),
            ],
          ),
          PinnedBottomWidget(
            child: SizedBox(
              width: double.infinity,
              child: CustomTonalButton(onPressed: () => Navigator.of(context).pop(), text: context.l10n.close),
            ),
          ),
        ],
      ),
    );
  }
}
