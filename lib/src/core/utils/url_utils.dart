import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class UrlUtils() {
  static Future<void> launchExternalUrl(BuildContext context, String url) async {
    final Uri link = Uri.parse(url);
    if (!await launchUrl(link, mode: LaunchMode.externalApplication) && context.mounted) {
      showErrorMessage(context, context.l10n.linkCannotBeOpenedInBrowser);
    }
  }
}
