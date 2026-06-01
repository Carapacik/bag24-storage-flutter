import 'dart:async';

import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/luggage_order/widget/rate_card.dart';
import 'package:bag24/src/feature/order/model/order_luggage.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Future<void> showLuggageBottomSheet(BuildContext context, {required OrderLuggage order}) async =>
    await showCustomModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height - 320),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: order.photoUrl,
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  colorBlendMode: BlendMode.srcOver,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator.adaptive(value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 16),
            RateCard(rate: order.rate),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: CustomTonalButton(onPressed: () => Navigator.of(context).pop(), text: context.l10n.close),
            ),
          ],
        ),
      ),
    );
