import 'dart:async';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/core/utils/local_notification_manager.dart';
import 'package:bag24/src/feature/home/widget/banners_widget.dart';
import 'package:bag24/src/feature/location/data/storage_store.dart';
import 'package:bag24/src/feature/permissions/data/permissions_repository.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:push_notification_interface/push_interface.dart';

class const HomeScreen({super.key}) extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState() extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      unawaited(_initPushNotification());
    });

    final StorageStore storageStore = StorageStore.instance;
    final String? storageId = storageStore.currentStorageId;
    if (storageId != null) {
      StorageStore.instance.resetId();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        unawaited(
          GoRouter.of(context).pushNamed(Routes.checkInLuggageOrder.name, pathParameters: {'storageId': storageId}),
        );
      });
    }
  }

  Future<void> _initPushNotification() async {
    final IPermissionsRepository permissionsRepository = context.dependencies.permissionsRepository;
    final IPushNotificationService pushNotificationProvider = context.dependencies.pushNotificationProvider;

    // Request permission for notification
    final bool? isNotificationEnabled = await permissionsRepository.isNotificationEnabled;
    if (!(isNotificationEnabled ?? false)) {
      final bool isNotificationGranted = await permissionsRepository.isNotificationGranted;
      await LocalNotificationManager().init();
      if (isNotificationGranted) {
        await permissionsRepository.setNotification(notification: true);
      }
    }

    // Request push notification provider
    await pushNotificationProvider.subscribeToTopic('all');

    pushNotificationProvider.messageStream.listen((data) async {
      unawaited(LocalNotificationManager().showNotification(data.title, data.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SvgPicture.asset(context.icons.bag24Logo, width: 80),
        ),
        leadingWidth: 96,
        backgroundColor: context.colors.baseBgSecondary,
      ),
      backgroundColor: context.colors.baseBgSecondary,
      body: const _Body(),
    );
  }
}

class const _Body() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      color: context.colors.baseBgPrimary,
      clipBehavior: Clip.antiAlias,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 24),
          const BannersWidget(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(context.l10n.services, style: context.textStyles.title2Emphasized),
          ),
          const SizedBox(height: 16),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: _ServicesPart()),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(context.l10n.usefulInformation, style: context.textStyles.title2Emphasized),
          ),
          const SizedBox(height: 16),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: _UsefulInfoPart()),
          const SafeArea(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

class const _ServicesPart() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final luggageStorageButton = _ServiceButton(
      onTap: () async {
        unawaited(context.dependencies.analytics.luggageStorageTracker.trackLuggageStorageOpened());
        await context.pushNamed(Routes.selectStorage.name);
      },
      title: context.l10n.leaveYourLuggage,
      text: context.l10n.useManualAndAutomaticStorageCameras,
      imagePath: Assets.images.leaveLuggage.path,
    );
    // ignore: unused_local_variable
    final flyPostButton = _ServiceButton(
      onTap: () async => await context.pushNamed(Routes.selectSendService.name),
      title: context.l10n.sendingParsels,
      text: context.l10n.fastDeliveryYourShipment,
      imagePath: Assets.images.flyPost.path,
    );
    return windowSize.maybeMap(
      compact: () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 140, child: luggageStorageButton),
          // const SizedBox(height: 8),
          // SizedBox(height: 140, child: flyPostButton),
        ],
      ),
      orElse: () => SizedBox(
        height: 200,
        child: Row(
          children: [
            Expanded(child: luggageStorageButton),
            const SizedBox(width: 16),
            // Expanded(child: flyPostButton),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}

class const _UsefulInfoPart() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final howWorksButton = _InfoButton(
      title: context.l10n.howAppWorks,
      icon: SvgPicture.asset(
        Assets.svg.question.path,
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
      ),
      onTap: () async {
        unawaited(context.dependencies.analytics.howItWorksTracker.trackHowItWorksPageOpened());
        await context.pushNamed(Routes.howWorksScreen.name);
      },
    );
    final faqButton = _InfoButton(
      title: context.l10n.questionsAndAnswers,
      icon: SvgPicture.asset(
        Assets.svg.messages.path,
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
      ),
      onTap: () async {
        unawaited(context.dependencies.analytics.helpPageTracker.trackHelpPageOpened());
        await context.pushNamed(Routes.faq.name);
      },
    );
    return windowSize.maybeMap(
      compact: () => SizedBox(
        height: 150,
        child: Row(
          children: [
            Expanded(child: howWorksButton),
            const SizedBox(width: 8),
            Expanded(child: faqButton),
          ],
        ),
      ),
      orElse: () => SizedBox(
        height: 200,
        child: Row(
          children: [
            SizedBox(width: 250, child: howWorksButton),
            const SizedBox(width: 8),
            SizedBox(width: 250, child: faqButton),
          ],
        ),
      ),
    );
  }
}

class const _ServiceButton({
  required final VoidCallback onTap,
  required final String title,
  required final String text,
  required final String imagePath,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double dimension = windowSize.maybeMap(compact: () => 140.0, orElse: () => 160.0);
    return Material(
      color: context.colors.cellBgPrimary,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.success.withAlpha(100),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(title, style: context.textStyles.bodyRegular),
                      const SizedBox(width: 4),
                      SvgPicture.asset(
                        Assets.svg.arrowRight.path,
                        height: 16,
                        width: 16,
                        colorFilter: ColorFilter.mode(context.colors.iconTertiary, BlendMode.srcIn),
                      ),
                    ],
                  ),
                  windowSize.maybeMap(compact: () => const SizedBox(height: 8), orElse: () => const Spacer()),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth - dimension - 16,
                        child: Text(
                          text,
                          style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textTertiary),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(imagePath, height: dimension, fit: BoxFit.fitWidth),
            ),
          ],
        ),
      ),
    );
  }
}

class const _InfoButton({required final String title, required final Widget icon, required final VoidCallback onTap})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: context.colors.cellBgPrimary,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        highlightColor: AppColors.success.withAlpha(100),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: context.colors.cellBgSecondary,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: Padding(padding: const EdgeInsets.all(10), child: icon),
              ),
              Text(title, style: context.textStyles.bodyRegular),
            ],
          ),
        ),
      ),
    );
  }
}
