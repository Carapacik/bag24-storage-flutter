import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class const ContactSupportData({
  required final String airport,
  required final String service,
  required final String topic,
  required final String comment,
}) {
  String? isValidAirport(BuildContext context) {
    if (airport.isEmpty) {
      return context.l10n.selectAirport;
    }

    return null;
  }

  String? isValidService(BuildContext context) {
    if (airport.isEmpty) {
      return context.l10n.selectService;
    }

    return null;
  }

  String? isValidTopic(BuildContext context) {
    if (topic.isEmpty) {
      return context.l10n.topicCannotBeEmpty;
    }
    const length = 150;
    if (topic.length > length) {
      return context.l10n.lengthCannotExceed(length);
    }

    return null;
  }

  String? isValidComment(BuildContext context) {
    if (comment.isEmpty) {
      return context.l10n.commentCannotBeEmpty;
    }
    const length = 500;
    if (comment.length > 500) {
      return context.l10n.lengthCannotExceed(length);
    }

    return null;
  }
}
