import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:flutter/material.dart';

class const NotificationsScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: context.l10n.notifications),
      body: ListView(),
    );
  }
}
