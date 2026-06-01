import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/luggage_order/model/luggage_item_model.dart';
import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';
import 'package:bag24/src/feature/luggage_order/model/rent_price.dart';
import 'package:bag24/src/feature/luggage_order/model/special_offer.dart';
import 'package:bag24/src/feature/luggage_order/widget/bottom_sheet/select_photo_method_bottom_sheet.dart';
import 'package:bag24/src/feature/luggage_order/widget/photo_rules_screen.dart';
import 'package:bag24/src/feature/luggage_order/widget/rate_card.dart';
import 'package:bag24/src/feature/luggage_order/widget/special_offer_card.dart';
import 'package:bag24/src/feature/luggage_order/widget/storage_conditions_screen.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/custom_tooltip.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/round_checkbox.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/info_container.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:bag24/src/feature/shared_widgets/layout/two_buttons.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

Future<LuggageItemModel?> showAddLuggageBottomSheet(
  BuildContext context, {
  required List<RateData> rates,
  LuggageItemModel? luggage,
  bool haveLuggage = true,
  bool isShownPhotoRules = true,
}) => showCustomModalBottomSheet<LuggageItemModel>(
  context: context,
  useRootNavigator: true,
  isScrollControlled: true,
  backgroundColor: context.colors.baseBgSecondary,
  dragBackgroundColor: context.colors.baseBgPrimary,
  builder: (_) {
    // for fullscreen
    final double height = MediaQuery.sizeOf(context).height;
    final double safeAreaPadding = MediaQueryData.fromView(ui.PlatformDispatcher.instance.implicitView!).padding.top;
    return SizedBox(
      height: height - 20 - safeAreaPadding,
      child: _AddLuggagePart(
        rates: rates,
        luggage: luggage,
        haveLuggage: haveLuggage,
        isShownPhotoRules: isShownPhotoRules,
      ),
    );
  },
);

class const _AddLuggagePart({
  required final List<RateData> rates,
  required final LuggageItemModel? luggage,
  required final bool haveLuggage,
  required final bool isShownPhotoRules,
}) extends StatefulWidget {
  @override
  State<_AddLuggagePart> createState() => _AddLuggagePartState();
}

class _AddLuggagePartState() extends State<_AddLuggagePart> {
  String? _photo;
  RateData? _selectedRate;
  SpecialOffer? _selectedSpecialOffer;

  @override
  void initState() {
    super.initState();
    if (widget.luggage != null) {
      _photo = widget.luggage!.photo;
      _selectedRate = widget.rates.firstWhereOrNull((e) => widget.luggage!.rateId == e.id);
      _selectedSpecialOffer = _selectedRate?.specialOffers?.firstWhereOrNull(
        (e) => widget.luggage!.specialOfferId == e.id,
      );
    } else {
      _selectedRate = widget.rates.first;
    }
  }

  Future<void> _addPhoto(BuildContext context) async {
    final WindowSize windowSize = WindowSizeScope.of(context, listen: false);
    String? photo;
    if (windowSize.isCompact && widget.isShownPhotoRules) {
      photo = await showSelectPhotoMethodBottomSheet(context);
    } else {
      photo = await windowSize.maybeMap(
        compact: () =>
            Navigator.of(context).push(MaterialPageRoute<String>(builder: (context) => const PhotoRulesScreen())),
        orElse: () => showDialog<String>(context: context, builder: (context) => const PhotoRulesScreen()),
      );
    }
    if (photo == null) {
      return;
    }
    setState(() => _photo = photo);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(
            top: MediaQuery.paddingOf(context).top + 56,
            bottom: MediaQuery.paddingOf(context).bottom + (_photo != null && !widget.haveLuggage ? 160 : 90),
          ),
          children: [
            _AttachPhotoWidget(photo: _photo, onAddPhoto: () async => await _addPhoto(context)),
            const SizedBox(height: 8),
            _RateWidget(
              selectedRate: _selectedRate,
              rates: widget.rates,
              onRateChanged: (rate) {
                setState(() => _selectedRate = rate);
              },
            ),
            if (_selectedRate != null) ...[
              const SizedBox(height: 8),
              _SpecialOffersWidget(
                selectedRate: _selectedRate!,
                selectedSpecialOffer: _selectedSpecialOffer,
                onSpecialOfferChanged: (specialOffer) => setState(() => _selectedSpecialOffer = specialOffer),
              ),
            ],
          ],
        ),
        SizedBox(
          height: 56,
          child: CustomAppBar(titleText: context.l10n.addingLuggage, leading: const Bag24CloseButton()),
        ),
        PinnedBottomWidget(
          child: _photo != null && !widget.haveLuggage
              ? TwoButtons(
                  firstWidget: CustomTonalButton(
                    onPressed: () {
                      context.pop(
                        LuggageItemModel(
                          photo: _photo!,
                          rateId: _selectedRate!.id,
                          specialOfferId: _selectedSpecialOffer?.id,
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(context.l10n.addNewLuggage),
                        const SizedBox(width: 8),
                        SvgPicture.asset(
                          Assets.svg.plus.path,
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                        ),
                      ],
                    ),
                  ),
                  secondWidget: GradientElevatedButton(
                    onPressed: () async => await Navigator.of(context).maybePop(
                      LuggageItemModel(
                        photo: _photo!,
                        rateId: _selectedRate!.id,
                        specialOfferId: _selectedSpecialOffer?.id,
                        needAdditionalLuggage: false,
                        createOrder: true,
                      ),
                    ),
                    text: context.l10n.placeAnOrder,
                  ),
                )
              : GradientElevatedButton(
                  onPressed: () async {
                    if (_photo == null) {
                      await _addPhoto(context);
                      return;
                    } else {
                      context.pop(
                        LuggageItemModel(
                          photo: _photo!,
                          rateId: _selectedRate!.id,
                          specialOfferId: _selectedSpecialOffer?.id,
                          needAdditionalLuggage: false,
                        ),
                      );
                    }
                  },
                  text: _photo == null
                      ? context.l10n.takePhotoOfYourLuggage
                      : widget.luggage == null
                      ? context.l10n.addToOrder
                      : context.l10n.changeLuggage,
                ),
        ),
      ],
    );
  }
}

class const _AttachPhotoWidget({required final String? photo, required final VoidCallback onAddPhoto})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double height = windowSize.maybeMap(compact: () => 120.0, orElse: () => 140.0);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.baseBgPrimary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.photo, style: context.textStyles.title3Emphasized),
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                children: [
                  SizedBox(
                    height: windowSize.isCompact ? 1.25 * height : height,
                    width: height,
                    child: _PhotoButton(photo: photo, onTap: onAddPhoto),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: windowSize.isCompact ? 1.25 * height : height,
                      child: InfoContainer(
                        isExpandedByHeight: true,
                        title: context.l10n.luggagePhoto,
                        text: context.l10n.toPlaceYourOrderCorrectly,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _RateWidget({
  required final RateData? selectedRate,
  required final List<RateData> rates,
  required final ValueChanged<RateData?> onRateChanged,
}) extends StatelessWidget {
  Future<RateData?> _showRateBottomSheet(BuildContext context) => showCustomModalBottomSheet<RateData>(
    context: context,
    useRootNavigator: true,
    builder: (context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(context.l10n.selectRate, style: context.textStyles.title3Emphasized),
        ),
        const SizedBox(height: 20),
        ListView.separated(
          itemCount: rates.length,
          primary: false,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => WindowSizeScope.of(context).maybeMap(
            compact: () => const SizedBox(height: 8),
            orElse: () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Divider(thickness: 1, height: 1, color: context.colors.borderSecondary),
            ),
          ),
          itemBuilder: (context, index) => ListTile(
            onTap: () {
              unawaited(context.dependencies.analytics.rateTracker.trackRateSelected(rates[index]));
              Navigator.of(context).pop(rates[index]);
            },
            title: Text(rates[index].title, style: context.textStyles.bodyRegular),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            trailing: RoundCheckbox(
              value: rates[index].id == selectedRate?.id,
              onChanged: (_) => Navigator.of(context).pop(rates[index]),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.baseBgPrimary,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.rate, style: context.textStyles.title3Emphasized),
            const SizedBox(height: 16),
            RateCard(
              onTap: () async {
                unawaited(context.dependencies.analytics.rateTracker.trackRateOpened());
                final RateData? newRate = await _showRateBottomSheet(context);
                if (newRate == null) {
                  return;
                }
                onRateChanged.call(newRate);
              },
              rate: selectedRate,
            ),
          ],
        ),
      ),
    );
  }
}

class const _PhotoButton({required final String? photo, required final VoidCallback onTap}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      color: context.colors.cellBgPrimary,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: photo != null
            ? Stack(
                fit: StackFit.expand,
                children: [
                  if (photo!.startsWith('http'))
                    CachedNetworkImage(imageUrl: photo!, fit: BoxFit.cover)
                  else
                    Image.file(File(photo!), fit: BoxFit.cover),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: SizedBox(
                      height: 24,
                      width: 24,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(color: context.colors.baseBgPrimary, shape: const CircleBorder()),
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.svg.edit.path,
                            width: 16,
                            height: 16,
                            colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Assets.svg.plus.path,
                    height: 32,
                    width: 32,
                    colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    context.l10n.add,
                    style: context.textStyles.caption1Regular.copyWith(color: context.colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }
}

class const _SpecialOffersWidget({
  required final RateData selectedRate,
  required final SpecialOffer? selectedSpecialOffer,
  required final ValueChanged<SpecialOffer?> onSpecialOfferChanged,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.baseBgPrimary,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpecialOfferCard(
              rate: selectedRate,
              title: context.l10n.daily,
              isSelected: selectedSpecialOffer == null,
              onTap: () => onSpecialOfferChanged.call(null),
              rentPrice: RentPrice(
                initialPrice: selectedRate.initialPrice ~/ 100,
                prolongingPrice: selectedRate.prolongingPrice ~/ 100,
              ),
            ),
            if (selectedRate.specialOffers?.isNotEmpty ?? false) ...[
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.specialOffers, style: context.textStyles.title3Emphasized),
                  const SizedBox(width: 4),
                  CustomTooltip(text: context.l10n.specialOffersTooltip, isLeft: true),
                ],
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                primary: false,
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: selectedRate.specialOffers!.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final SpecialOffer offer = selectedRate.specialOffers![index];
                  return SpecialOfferCard(
                    rate: selectedRate,
                    title: offer.name,
                    isSelected: selectedSpecialOffer?.id == offer.id,
                    onTap: () => onSpecialOfferChanged.call(offer),
                    rentPrice: RentPrice(
                      initialPrice: selectedRate.initialPrice ~/ 100,
                      prolongingPrice: selectedRate.prolongingPrice ~/ 100,
                      basePrice: offer.basePrice ~/ 100,
                      days: offer.days,
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 24),
            Material(
              color: context.colors.cellBgPrimary,
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () async {
                  final WindowSize windowSize = WindowSizeScope.of(context, listen: false);
                  await windowSize.maybeMap(
                    compact: () =>
                        Navigator.of(context)
                            .push(MaterialPageRoute<void>(builder: (context) => const StorageConditionsScreen())),
                    orElse: () =>
                        showDialog<void>(context: context, builder: (context) => const StorageConditionsScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 44,
                        width: 44,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.colors.baseBgPrimary,
                            borderRadius: const BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              Assets.svg.question.path,
                              height: 24,
                              width: 24,
                              colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.storageConditions, style: context.textStyles.bodyRegular),
                          const SizedBox(height: 2),
                          Text(
                            context.l10n.weAnswerYourQuestions,
                            style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textTertiary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
