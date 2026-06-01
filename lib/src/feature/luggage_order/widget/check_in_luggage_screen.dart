import 'dart:async';
import 'dart:io';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/analytics/data/luggage_storage_booking_type.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/luggage_order/bloc/check_in_luggage/check_in_luggage_bloc.dart';
import 'package:bag24/src/feature/luggage_order/model/luggage_item_model.dart';
import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';
import 'package:bag24/src/feature/luggage_order/widget/bottom_sheet/add_luggage_bottom_sheet.dart';
import 'package:bag24/src/feature/luggage_order/widget/luggage_card.dart';
import 'package:bag24/src/feature/orders/bloc/active_orders/active_orders_bloc.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/icon_with_description_tile.dart';
import 'package:bag24/src/feature/shared_widgets/common/info_container.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:bag24/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:bag24/src/feature/shared_widgets/modal/dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class const CheckInLuggageScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return BlocConsumer<CheckInLuggageBloc, CheckInLuggageState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (s) {
            Navigator.of(context).pop();
            unawaited(context.pushNamed(Routes.orderCreated.name, pathParameters: {'orderId': s.orderId}));
            unawaited(
              context.dependencies.analytics.luggageStorageTracker.trackLuggageStorageBooking(
                LuggageStorageBookingProgress.completed,
              ),
            );
            context.read<ActiveOrdersBloc>().add(const ActiveOrdersEvent.start());
          },
          failure: (s) => showCustomAppException(context, s.exception),
        );
      },
      builder: (context, state) {
        return FullScreenLoading(
          inProgress: state.inProgress,
          child: Scaffold(
            appBar: CustomAppBar(
              backgroundColor: context.colors.baseBgSecondary,
              title: Column(
                crossAxisAlignment: windowSize.isCompact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  Text(context.l10n.passLuggage, style: context.textStyles.bodyEmphasized),
                  Text(
                    context.l10n.step2of2,
                    style: context.textStyles.caption1Regular.copyWith(color: context.colors.textTertiary),
                  ),
                ],
              ),
              leading: Bag24BackButton(
                onPressed: () async {
                  unawaited(
                    context.dependencies.analytics.luggageStorageTracker.trackLuggageStorageBooking(
                      LuggageStorageBookingProgress.canceled,
                    ),
                  );
                  await Navigator.of(context).maybePop();
                },
              ),
            ),
            backgroundColor: context.colors.baseBgSecondary,
            body: Stack(
              children: [
                const _Body(),
                LinearProgressIndicator(
                  value: 0.55,
                  minHeight: 4,
                  backgroundColor: context.colors.buttonBgTertiary,
                  valueColor: AlwaysStoppedAnimation(context.colors.progressBar),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class const _Body() extends StatefulWidget {
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState() extends State<_Body> {
  final List<LuggageItemModel> _luggageList = [];
  bool _isDemonstratedSlide = false;

  Future<void> _addLuggage(
    BuildContext context, {
    required List<RateData> rates,
    required bool isShownPhotoRules,
  }) async {
    final CheckInLuggageBloc bloc = context.read<CheckInLuggageBloc>();
    final LuggageItemModel? result = await showAddLuggageBottomSheet(
      context,
      rates: rates,
      haveLuggage: _luggageList.isNotEmpty,
      isShownPhotoRules: isShownPhotoRules,
    );
    if (result == null) {
      return;
    }
    setState(() {
      _luggageList.add(result);
      if (_luggageList.length > 1) {
        _isDemonstratedSlide = true;
      }
      bloc.add(const CheckInLuggageEvent.shownPhotoRules());
    });
    if (result.createOrder) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      bloc.add(CheckInLuggageEvent.create(_luggageList));
      return;
    }
    if (result.needAdditionalLuggage && context.mounted) {
      await _addLuggage(context, rates: rates, isShownPhotoRules: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double imageHeight = windowSize.maybeMap(compact: () => 160.0, orElse: () => 250.0);
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(top: 4, bottom: 90 + MediaQuery.paddingOf(context).bottom),
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.baseBgPrimary,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: BlocBuilder<CheckInLuggageBloc, CheckInLuggageState>(
                  builder: (context, state) {
                    return Shimmer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.placeAndTime, style: context.textStyles.title3Emphasized),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: state.storage != null
                                  ? CachedNetworkImage(
                                      imageUrl: state.storage!.photoUrl,
                                      height: imageHeight,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => ShimmerLoading(
                                        inProgress: true,
                                        child: SizedBox(width: double.infinity, height: imageHeight),
                                      ),
                                    )
                                  : ShimmerLoading(
                                      inProgress: true,
                                      child: SizedBox(width: double.infinity, height: imageHeight),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (state.storage != null)
                            IconWithDescriptionTile(
                              icon: Assets.svg.clock.path,
                              text: context.l10n.bookingOn(DateFormat('dd.MM.yyyy, HH:mm').format(DateTime.now())),
                            )
                          else
                            const ShimmerLoading(inProgress: true, child: SizedBox(height: 20, width: 300)),
                          const SizedBox(height: 16),
                          if (state.storage != null)
                            IconWithDescriptionTile(icon: Assets.svg.location.path, text: state.storage?.fullName ?? '')
                          else
                            const ShimmerLoading(inProgress: true, child: SizedBox(height: 20, width: 200)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(color: context.colors.baseBgPrimary, borderRadius: BorderRadius.circular(24)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: BlocBuilder<CheckInLuggageBloc, CheckInLuggageState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.luggage, style: context.textStyles.title3Emphasized),
                        if (_luggageList.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ListView.separated(
                            primary: false,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _luggageList.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final LuggageItemModel luggage = _luggageList[index];
                              final RateData rate = state.storage!.rates.firstWhere((r) => r.id == luggage.rateId);
                              return LuggageCard(
                                key: ValueKey(luggage.photo),
                                needShowDemonstration: !_isDemonstratedSlide,
                                rate: rate,
                                specialOffer: rate.specialOffers?.firstWhereOrNull(
                                  (e) => e.id == luggage.specialOfferId,
                                ),
                                image: Image.file(File(luggage.photo), height: 44, width: 44, fit: BoxFit.cover),
                                onDelete: () async {
                                  final bool? result = await showCustomAlertDialog(
                                    context: context,
                                    title: context.l10n.removeLuggage,
                                    content: context.l10n.areYouSureToRemoveLuggage,
                                    actionText: context.l10n.yes,
                                    cancelText: context.l10n.cancel,
                                  );
                                  if (result == null || !result) {
                                    return;
                                  }
                                  setState(() {
                                    _luggageList.removeAt(index);
                                  });
                                },
                                onEdit: () async {
                                  final LuggageItemModel? result = await showAddLuggageBottomSheet(
                                    context,
                                    rates: state.storage!.rates,
                                    luggage: luggage,
                                    isShownPhotoRules: state.isShownPhotoRules,
                                  );
                                  if (result == null) {
                                    return;
                                  }
                                  setState(() {
                                    _luggageList[index] = result;
                                  });
                                },
                              );
                            },
                          ),
                        ],
                        if (_luggageList.length < 10) ...[
                          const SizedBox(height: 20),
                          CustomTonalButton(
                            onPressed: state.storage == null
                                ? null
                                : () async => await _addLuggage(
                                    context,
                                    rates: state.storage!.rates,
                                    isShownPhotoRules: state.isShownPhotoRules,
                                  ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(context.l10n.addLuggage),
                                SvgPicture.asset(
                                  Assets.svg.plus.path,
                                  height: 24,
                                  width: 24,
                                  colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        InfoContainer(
                          title: context.l10n.howToAddLuggageCorrectlyTitle,
                          text: context.l10n.howToAddLuggageCorrectlyText,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        PinnedBottomWidget(
          child: GradientElevatedButton(
            onPressed: _luggageList.isEmpty
                ? null
                : () => context.read<CheckInLuggageBloc>().add(CheckInLuggageEvent.create(_luggageList)),
            child: Text(context.l10n.placeAnOrder),
          ),
        ),
      ],
    );
  }
}
