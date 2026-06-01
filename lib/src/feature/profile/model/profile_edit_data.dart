import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class const ProfileEditData({required final String firstName, required final String lastName}) {
  String? isValidFirstName(BuildContext context) {
    if (firstName.isEmpty) {
      return context.l10n.nameCannotBeEmpty;
    }
    if (firstName.length > 20) {
      return context.l10n.nameMustLessThen;
    }
    if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(firstName)) {
      return context.l10n.nameContainOnlyLetters;
    }

    return null;
  }

  String? isValidLastName(BuildContext context) {
    if (lastName.isEmpty) {
      return context.l10n.lastNameCannotBeEmpty;
    }
    if (lastName.length > 20) {
      return context.l10n.lastNameMustLessThen;
    }
    if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(lastName)) {
      return context.l10n.lastNameContainOnlyLetters;
    }

    return null;
  }
}
