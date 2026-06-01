import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

enum ServiceType() {
  storageCamera,
  lostInAirport;

  String localizedText(BuildContext context) => switch (this) {
    ServiceType.storageCamera => context.l10n.luggageStorage,
    ServiceType.lostInAirport => context.l10n.lostItemInAirport,
  };
}
