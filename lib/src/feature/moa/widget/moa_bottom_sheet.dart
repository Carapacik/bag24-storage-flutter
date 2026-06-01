import 'dart:async';

import 'package:bag24/src/core/constant/constants.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> showMoaBottomSheet(BuildContext context, {required VoidCallback onJoinPressed}) =>
    showCustomModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      padding: const EdgeInsets.all(16),
      builder: (context) => SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.bonusProgram,
              style: context.textStyles.title2Emphasized.copyWith(color: context.colors.textPrimary),
            ),
            SvgPicture.asset(context.icons.mileOnAirLogo, width: 120),
            const SizedBox(height: 20),
            Text(
              context.l10n.moaBonusProgramDescription,
              style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomTonalButton(
                onPressed: () {
                  onJoinPressed.call();
                  context.pop();
                },
                text: context.l10n.iAmParticipant,
                backgroundColor: const Color(0xFF3B3252),
                foregroundColor: context.colors.textPrimaryInverse,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: CustomTonalButton(
                onPressed: () async => await launchUrl(Uri.parse(moaBonusUrl)),
                text: context.l10n.learnMoreAboutProgram,
                backgroundColor: context.colors.mileOnAir,
                foregroundColor: context.colors.textPrimaryInverse,
              ),
            ),
          ],
        ),
      ),
    );
