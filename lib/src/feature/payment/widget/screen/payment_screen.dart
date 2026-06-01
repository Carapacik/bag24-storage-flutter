import 'dart:async';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/resources/resources.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/moa/bloc/moa/moa_bloc.dart';
import 'package:bag24/src/feature/moa/widget/moa_sms_code_bottom_sheet.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/order/widget/order_payments_widget.dart';
import 'package:bag24/src/feature/orders/bloc/active_orders/active_orders_bloc.dart';
import 'package:bag24/src/feature/payment/bloc/binding_cards/binding_cards_bloc.dart';
import 'package:bag24/src/feature/payment/bloc/payment/payment_bloc.dart';
import 'package:bag24/src/feature/payment/model/binding_model.dart';
import 'package:bag24/src/feature/payment/model/payment_method_type.dart';
import 'package:bag24/src/feature/payment/model/payment_status.dart';
import 'package:bag24/src/feature/payment/model/payment_system_enum.dart';
import 'package:bag24/src/feature/payment/widget/add_link_card_sheet.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/common/discount_badge.dart';
import 'package:bag24/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class const PaymentScreen({
  required final String orderId,
  required final OrderStatus orderStatus,
  required final int costPerDay,
  required final int discount,
  required final int amountToPay,
  final bool useAutoCharge = true,
  super.key,
}) extends StatefulWidget {
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState() extends State<PaymentScreen> {
  int _milesToUse = 0;
  bool _isCardsOpened = false;
  bool _isMileOnAirEnabled = false;

  Future<void> _processPayment(
    BuildContext context, {
    required PaymentMethodType paymentMethodType,
    String? bindingId,
  }) async {
    final BindingResult? bindingResult = await _handleBindingResult(context, paymentMethodType: paymentMethodType);

    if (_shouldSkipPayment(bindingResult, paymentMethodType)) {
      return;
    }
    if (context.mounted) {
      context.read<PaymentBloc>().add(
        PaymentEvent.processPayment(
          paymentMethodType: paymentMethodType,
          bindingId: bindingId,
          bindingResult: bindingResult,
          milesToUse: _milesToUse,
        ),
      );
    }

    if (context.mounted && _milesToUse != 0) {
      await _handleMileOnAirPayment(context);
      return;
    }

    if (context.mounted) {
      context.read<PaymentBloc>().add(const PaymentEvent.checkPaymentStatus());
    }
  }

  Future<BindingResult?> _handleBindingResult(
    BuildContext context, {
    required PaymentMethodType paymentMethodType,
  }) async {
    if (!_needsBindingResult(paymentMethodType)) {
      return BindingResult(isBindCard: false, isAutoCharge: false);
    }

    return await showCustomModalBottomSheet<BindingResult>(
      context: context,
      padding: const EdgeInsets.all(16),
      builder: (context) => AddLinkCardBottomSheet(
        showBindCardSwitch: paymentMethodType != PaymentMethodType.binding,
        showAutoCharge: widget.useAutoCharge,
      ),
    );
  }

  bool _needsBindingResult(PaymentMethodType paymentMethodType) {
    return widget.orderStatus == OrderStatus.created &&
        (paymentMethodType == PaymentMethodType.bankCard ||
            (widget.useAutoCharge && paymentMethodType == PaymentMethodType.binding));
  }

  bool _shouldSkipPayment(BindingResult? bindingResult, PaymentMethodType paymentMethodType) {
    return bindingResult == null &&
        (paymentMethodType != PaymentMethodType.sbp && paymentMethodType != PaymentMethodType.sberbank);
  }

  Future<void> _handleMileOnAirPayment(BuildContext context) async {
    final bool? result = await showMoaSmsCodeBottomSheet(context, orderId: widget.orderId);
    if (!context.mounted) {
      return;
    }
    if (result != null && result) {
      context.read<PaymentBloc>().add(const PaymentEvent.checkPaymentStatus());
    } else {
      context.read<PaymentBloc>().add(const PaymentEvent.cancelPayment());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) async {
        state.mapOrNull(
          failure: (s) => showCustomAppException(context, s.exception),
          success: (s) async {
            if (s.paymentStatus == PaymentStatus.inProgress && s.paymentUrl != null) {
              final bool? result = await context.pushNamed<bool>(
                Routes.paymentWebView.name,
                pathParameters: {'url': s.paymentUrl!},
              );

              if (context.mounted && (result ?? false)) {
                await _goToResultScreen(
                  context: context,
                  orderId: s.orderId,
                  luggageIds: s.luggageIds,
                  paymentStatus: PaymentStatus.succeeded,
                  orderStatus: s.orderStatus,
                );
              }
            } else {
              await _goToResultScreen(
                context: context,
                orderId: s.orderId,
                luggageIds: s.luggageIds,
                paymentStatus: s.paymentStatus,
                orderStatus: s.orderStatus,
              );
            }
          },
        );
      },
      builder: (context, state) {
        return FullScreenLoading(
          inProgress: state.inProgress,
          child: Scaffold(
            backgroundColor: context.colors.baseBgSecondary,
            appBar: CustomAppBar(
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  onPressed: () async => await Navigator.of(context).maybePop(),
                  icon: SvgPicture.asset(
                    Assets.svg.close.path,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.baseBgPrimary,
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Text(context.l10n.paymentMethod, style: context.textStyles.title3Emphasized),
                          _PaymentItemWidget(
                            iconPath: Assets.svg.sbp.path,
                            title: context.l10n.fastPaymentSystem,
                            subTitle: context.l10n.viaBankApp,
                            onTap: () async => await _processPayment(context, paymentMethodType: PaymentMethodType.sbp),
                          ),
                          _PaymentMethodsSection(
                            isCardsOpened: _isCardsOpened,
                            onCardsToggle: () {
                              setState(() => _isCardsOpened = !_isCardsOpened);
                            },
                            useAutoCharge: widget.useAutoCharge,
                            onProcessPayment: _processPayment,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<MOABloc, MOAState>(
                    builder: (context, moaState) {
                      if (moaState.isJoined) {
                        return _MileOnAirPaymentWidget(
                          miles: moaState.miles,
                          isMileOnAirEnabled: _isMileOnAirEnabled,
                          onChange: ({required miles, required use}) {
                            final int totalAmount = widget.amountToPay != 0
                                ? widget.amountToPay - 1
                                : widget.costPerDay - 1 + widget.discount;
                            _isMileOnAirEnabled = use;
                            _milesToUse = use ? (miles >= totalAmount ? totalAmount : miles) : 0;
                            setState(() {});
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 8),
                  OrderPaymentsWidget(
                    title: context.l10n.amountDue,
                    costOfLuggageStorage: widget.costPerDay,
                    discount: widget.discount,
                    additionalPayment: widget.amountToPay,
                    paidAmount: 0,
                    additionalServicesTotal: 0,
                    useMiles: _isMileOnAirEnabled,
                    miles: _milesToUse,
                  ),
                  SizedBox(height: 8 + MediaQuery.paddingOf(context).bottom),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _goToResultScreen({
    required BuildContext context,
    required String orderId,
    required List<String> luggageIds,
    required PaymentStatus paymentStatus,
    required OrderStatus orderStatus,
  }) async {
    final GoRouter router = GoRouter.of(context);
    switch (paymentStatus) {
      case PaymentStatus.created:
      case PaymentStatus.inProgress:
        await router.pushReplacementNamed(Routes.paymentInProgress.name);
      case PaymentStatus.succeeded:
        context.read<ActiveOrdersBloc>().add(const ActiveOrdersEvent.start());
        await router.pushReplacementNamed(
          Routes.paymentResult.name,
          queryParameters: {
            'orderId': orderId,
            'successResult': true.toString(),
            'orderStatus': orderStatus.json,
            'luggageIds': luggageIds.join('|'),
          },
        );
      case PaymentStatus.failed:
        await router.pushNamed(
          Routes.paymentResult.name,
          queryParameters: {'orderId': orderId, 'successResult': false.toString(), 'orderStatus': orderStatus.json},
        );
      case PaymentStatus.unknown:
    }
  }
}

class const _PaymentMethodsSection({
  required final bool isCardsOpened,
  required final VoidCallback onCardsToggle,
  required final bool useAutoCharge,
  required final Future<void> Function(
    BuildContext context, {
    required PaymentMethodType paymentMethodType,
    String? bindingId,
  })
  onProcessPayment,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PaymentItemWidget(
          iconPath: Assets.svg.card.path,
          title: context.l10n.allPaymentMethods,
          subTitle: context.l10n.supportedCardTypes,
          onTap: onCardsToggle,
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(16),
            bottom: Radius.circular(isCardsOpened ? 0 : 16),
          ),
          iconColorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
          rightContent: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: isCardsOpened ? 0.0 : 0.5, end: isCardsOpened ? 0.5 : 0.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 2 * 3.14,
                child: SvgPicture.asset(
                  Assets.svg.arrowDown.path,
                  colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
                ),
              );
            },
          ),
        ),
        if (isCardsOpened) ...[
          Divider(color: context.colors.borderPrimary, thickness: 1, height: 1),
          _CardsListSection(useAutoCharge: useAutoCharge, onProcessPayment: onProcessPayment),
        ],
      ],
    );
  }
}

class const _CardsListSection({
  required final bool useAutoCharge,
  required final Future<void> Function(
    BuildContext context, {
    required PaymentMethodType paymentMethodType,
    String? bindingId,
  })
  onProcessPayment,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BindingCardsBloc, BindingCardsState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: state.cards.length * 76 + 153,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _PaymentItemWidget(
                  iconPath: Assets.svg.sberPay.path,
                  title: context.l10n.sberPay,
                  subTitle: context.l10n.contactlessPayment,
                  onTap: () async => await onProcessPayment(context, paymentMethodType: PaymentMethodType.sberbank),
                  borderRadius: BorderRadius.zero,
                  iconColorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
                ),
                ...state.cards.map(
                  (card) => _PaymentItemWidget(
                    key: ValueKey(card.id),
                    iconPath: PaymentSystemEnum.fromString(card.cardType).imagePath,
                    title: PaymentSystemEnum.fromString(card.cardType).localizedText(context, card.last4),
                    borderRadius: BorderRadius.zero,
                    onTap: () async => await onProcessPayment(
                      context,
                      paymentMethodType: PaymentMethodType.binding,
                      bindingId: card.id,
                    ),
                  ),
                ),
                _PaymentItemWidget(
                  iconPath: Assets.svg.cardAdd.path,
                  title: context.l10n.newCard,
                  subTitle: context.l10n.supportedCardTypes,
                  onTap: () async => await onProcessPayment(context, paymentMethodType: PaymentMethodType.bankCard),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  iconColorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class const _MileOnAirPaymentWidget({
  required final int miles,
  required final bool isMileOnAirEnabled,
  required final void Function({required int miles, required bool use}) onChange,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: context.colors.baseBgPrimary, borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(context.l10n.bonusProgram, style: context.textStyles.title3Emphasized),
                const SizedBox(width: 4),
                SvgPicture.asset(context.icons.mileOnAirLogo, width: 80),
              ],
            ),
            const SizedBox(height: 16),
            DecoratedBox(
              decoration: BoxDecoration(color: context.colors.baseBgSecondary, borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(context.l10n.writeOff, style: context.textStyles.bodyRegular),
                        const SizedBox(width: 6),
                        DiscountBadge(discount: '$miles М', gradient: AppColors.gradientMileOnAir),
                      ],
                    ),
                    CupertinoSwitch(
                      value: isMileOnAirEnabled,
                      activeTrackColor: context.colors.mileOnAir,
                      onChanged: miles != 0 ? (value) => onChange(miles: miles, use: value) : null,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _PaymentItemWidget({
  required final String iconPath,
  required final String title,
  required final VoidCallback onTap,
  final String subTitle = '',
  final BorderRadius borderRadius = const BorderRadius.all(Radius.circular(16)),
  final Widget? rightContent,
  final ColorFilter? iconColorFilter,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius,
      color: context.colors.buttonBgTertiary,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 44,
                    width: 44,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        color: context.colors.baseBgPrimary,
                      ),
                      child: Center(
                        child: SvgPicture.asset(iconPath, height: 24, width: 24, colorFilter: iconColorFilter),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.textStyles.bodyRegular.copyWith(color: context.colors.textPrimary)),
                      if (subTitle.isNotEmpty)
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.55,
                          child: Text(
                            subTitle,
                            style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              ?rightContent,
            ],
          ),
        ),
      ),
    );
  }
}
