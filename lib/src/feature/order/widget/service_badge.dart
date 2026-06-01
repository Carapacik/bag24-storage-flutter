import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ServiceBadgeType() {
  luggageStorage,
  lostAndFound,
}

class const ServiceBadgeWidget({required final ServiceBadgeType type, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String imagePath;
    String text;

    switch (type) {
      case ServiceBadgeType.luggageStorage:
        imagePath = Assets.svg.luggageStorageBadge.path;
        text = context.l10n.manualLuggageStorage;
      case ServiceBadgeType.lostAndFound:
        imagePath = Assets.svg.foundBadge.path;
        text = 'Lost & Found';
    }

    return DecoratedBox(
      decoration: ShapeDecoration(color: context.colors.badgeBgPrimary, shape: const StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(imagePath, height: 16, width: 16),
            const SizedBox(width: 8),
            Text(text, style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
