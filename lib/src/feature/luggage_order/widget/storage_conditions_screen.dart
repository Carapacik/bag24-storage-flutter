import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const StorageConditionsScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final List<({String description, String iconPath, String title})> conditions = [
      (
        iconPath: Assets.svg.money.path,
        title: context.l10n.storageConditionsTitle1,
        description: context.l10n.storageConditionsDescription1,
      ),
      (
        iconPath: Assets.svg.calendar.path,
        title: context.l10n.storageConditionsTitle2,
        description: context.l10n.storageConditionsDescription2,
      ),
      (
        iconPath: Assets.svg.clock.path,
        title: context.l10n.storageConditionsTitle3,
        description: context.l10n.storageConditionsDescription3,
      ),
      (
        iconPath: Assets.svg.luggage.path,
        title: context.l10n.storageConditionsTitle4,
        description: context.l10n.storageConditionsDescription4,
      ),
      (
        iconPath: Assets.svg.update.path,
        title: context.l10n.storageConditionsTitle5,
        description: context.l10n.storageConditionsDescription5,
      ),
      (
        iconPath: Assets.svg.bag.path,
        title: context.l10n.storageConditionsTitle6,
        description: context.l10n.storageConditionsDescription6,
      ),
    ];
    final children = [
      ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        itemCount: conditions.length,
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.fromLTRB(60, 16, 0, 16),
          child: Divider(height: 1, thickness: 1, color: context.colors.borderPrimary),
        ),
        itemBuilder: (context, index) {
          return _ConditionWidget(
            iconPath: conditions[index].iconPath,
            title: conditions[index].title,
            description: conditions[index].description,
          );
        },
      ),
    ];

    return windowSize.maybeMap(
      compact: () => Scaffold(
        appBar: const CustomAppBar(leading: Bag24CloseButton()),
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.paddingOf(context).bottom + 90),
              children: [
                Text(context.l10n.storageConditions, style: context.textStyles.title1Emphasized),
                const SizedBox(height: 24),
                ...children,
              ],
            ),
            PinnedBottomWidget(
              child: CustomTonalButton(
                onPressed: () async => await Navigator.of(context).maybePop(),
                text: context.l10n.close,
              ),
            ),
          ],
        ),
      ),
      orElse: () => Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: windowSize.isCompact ? 16 : ((MediaQuery.sizeOf(context).width - compactMaxWidth) / 2 - 16),
        ),
        backgroundColor: context.colors.baseBgPrimary,
        surfaceTintColor: context.colors.baseBgPrimary,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(context.l10n.storageConditions, style: context.textStyles.title1Emphasized),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.close, color: context.colors.iconPrimaryInverse, size: 32),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView(padding: EdgeInsets.zero, shrinkWrap: true, children: children),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomTonalButton(
                  onPressed: () async => await Navigator.of(context).maybePop(),
                  text: context.l10n.close,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _ConditionWidget({
  required final String iconPath,
  required final String title,
  required final String description,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 44,
          width: 44,
          child: DecoratedBox(
            decoration: ShapeDecoration(color: context.colors.buttonBgTertiary, shape: const CircleBorder()),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textStyles.bodyRegular.copyWith(color: context.colors.textPrimary)),
              const SizedBox(height: 4),
              Text(
                description,
                style: context.textStyles.subheadlineRegular16.copyWith(color: context.colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
