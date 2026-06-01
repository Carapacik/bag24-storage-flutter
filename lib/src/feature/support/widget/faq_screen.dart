import 'dart:async';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:bag24/src/feature/support/model/instruction_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class const FaqScreen({final String? airport, final String? orderId, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<InstructionData> instructions = InstructionData.instructions(context);
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.paddingOf(context).bottom + 90),
            children: [
              Text(context.l10n.questionsAndAnswers, style: context.textStyles.title1Emphasized),
              const SizedBox(height: 16),
              Text(
                context.l10n.weAnswerTheMostFrequentQuestions,
                style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                padding: EdgeInsets.zero,
                primary: false,
                shrinkWrap: true,
                itemCount: instructions.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final InstructionData item = instructions[index];
                  return _HelpVariableButton(
                    title: item.title,
                    onTap: () async {
                      unawaited(context.dependencies.analytics.helpPageTracker.trackHelpTopicSelected(item.title));
                      await context.pushNamed(
                        Routes.instruction.name,
                        queryParameters: {'title': item.title, 'description': item.description},
                      );
                    },
                  );
                },
              ),
            ],
          ),
          PinnedBottomWidget(
            child: GradientElevatedButton(
              onPressed: () async => await context.pushNamed(
                Routes.support.name,
                queryParameters: {'airport': airport, 'orderId': orderId},
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.writeToSupport),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    Assets.svg.messages.path,
                    height: 24,
                    width: 24,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class const _HelpVariableButton({required final String title, required final VoidCallback onTap})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.cellBgPrimary,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(child: Text(title, style: context.textStyles.bodyRegular)),
              const SizedBox(width: 4),
              SvgPicture.asset(
                Assets.svg.arrowRight.path,
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(context.colors.iconTertiary, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
