import 'dart:io';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/luggage_order/model/luggage_item_model.dart';
import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';
import 'package:bag24/src/feature/luggage_order/widget/bottom_sheet/add_luggage_bottom_sheet.dart';
import 'package:bag24/src/feature/luggage_order/widget/luggage_card.dart';
import 'package:bag24/src/feature/order/bloc/order_composition/order_composition_bloc.dart';
import 'package:bag24/src/feature/order/bloc/order_detail/order_detail_bloc.dart';
import 'package:bag24/src/feature/order/model/order_detail.dart';
import 'package:bag24/src/feature/order/model/order_luggage.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/order/model/step_status.dart';
import 'package:bag24/src/feature/order/widget/bottom_sheet/luggage_bottom_sheet.dart';
import 'package:bag24/src/feature/order/widget/bottom_sheet/qr_code_bottom_sheet.dart';
import 'package:bag24/src/feature/order/widget/order_initial_processing_widget.dart';
import 'package:bag24/src/feature/order/widget/order_options_button.dart';
import 'package:bag24/src/feature/order/widget/order_payments_widget.dart';
import 'package:bag24/src/feature/order/widget/order_status_badge.dart';
import 'package:bag24/src/feature/order/widget/service_badge.dart';
import 'package:bag24/src/feature/order/widget/storage_time_widget.dart';
import 'package:bag24/src/feature/orders/bloc/active_orders/active_orders_bloc.dart';
import 'package:bag24/src/feature/orders/bloc/inactive_orders/inactive_orders_bloc.dart';
import 'package:bag24/src/feature/payment/model/payment_method_type.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/round_checkbox.dart';
import 'package:bag24/src/feature/shared_widgets/button/show_qr_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/icon_with_description_tile.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:bag24/src/feature/shared_widgets/custom_painter/top_gradient_painter.dart';
import 'package:bag24/src/feature/shared_widgets/loading/custom_circular_progress_indicator.dart';
import 'package:bag24/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:bag24/src/feature/shared_widgets/modal/dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class const OrderDetailScreen({super.key}) extends StatefulWidget {
  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState() extends State<OrderDetailScreen> with RouteAware {
  late final ScrollController _scrollController = ScrollController();
  late final AppLifecycleListener _appLifecycleListener;
  static const _appBarExpandedHeight = 320.0;
  final ValueNotifier<Set<OrderLuggage>> _selectedLuggage = ValueNotifier({});

  bool get _isSliverAppBarExpanded =>
      _scrollController.hasClients && _scrollController.offset > _appBarExpandedHeight - 56;

  @override
  void didPopNext() {
    context.read<OrderDetailBloc>().add(const OrderDetailEvent.updateStatus());
    super.didPopNext();
  }

  @override
  void initState() {
    super.initState();
    final OrderDetailBloc bloc = context.read<OrderDetailBloc>();
    _appLifecycleListener = AppLifecycleListener(
      onInactive: () => bloc.add(const OrderDetailEvent.cancelListening()),
      onHide: () => bloc.add(const OrderDetailEvent.cancelListening()),
      onResume: () => bloc.add(const OrderDetailEvent.startListening()),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectedLuggage.dispose();
    _appLifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrderDetailBloc, OrderDetailState>(
          listener: (context, state) {
            state.mapOrNull(
              failure: (s) => showCustomAppException(context, s.exception),
              success: (s) {
                _selectedLuggage.value = s.order.luggage.where((e) => e.status != OrderLuggageStatus.withdrawn).toSet();
              },
            );
          },
        ),
        BlocListener<OrderCompositionBloc, OrderCompositionState>(
          listener: (context, state) {
            state.mapOrNull(
              failure: (s) => showCustomAppException(context, s.exception),
              success: (s) {
                context.read<OrderDetailBloc>().add(const OrderDetailEvent.updateStatus(updateComposition: true));
                context.read<ActiveOrdersBloc>().add(const ActiveOrdersEvent.start());
                context.read<InactiveOrdersBloc>().add(const InactiveOrdersEvent.start());
              },
            );
          },
        ),
      ],
      child: BlocBuilder<OrderDetailBloc, OrderDetailState>(
        builder: (context, state) {
          final Size size = MediaQuery.sizeOf(context);
          final OrderDetail? order = state.order;
          final bool inFullProgress =
              state.inProgress || (order?.status == OrderStatus.depositing || order?.status == OrderStatus.withdrawing);
          return FullScreenLoading(
            inProgress: inFullProgress,
            text: switch (order?.status) {
              OrderStatus.depositing => '${context.l10n.luggageTransferred}...',
              OrderStatus.withdrawing => '${context.l10n.luggageIssued}...',
              _ => null,
            },
            child: Scaffold(
              backgroundColor: context.colors.baseBgSecondary,
              body: Stack(
                children: [
                  ListenableBuilder(
                    listenable: _scrollController,
                    builder: (context, child) {
                      if (_isSliverAppBarExpanded) {
                        return ColoredBox(color: context.colors.baseBgSecondary, child: const SizedBox.expand());
                      } else {
                        return CustomPaint(size: Size(size.width, size.height), painter: TopGradientPainter());
                      }
                    },
                  ),
                  if (state.inInitialProgress)
                    const OrderInitialProcessingWidget()
                  else if (order != null) ...[
                    CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        ListenableBuilder(
                          listenable: _scrollController,
                          builder: (context, child) {
                            return SliverAppBar(
                              expandedHeight:
                                  _appBarExpandedHeight + (order.shouldShowQrCodeWithDescription() ? 0 : -116),
                              centerTitle: true,
                              pinned: true,
                              backgroundColor: _isSliverAppBarExpanded
                                  ? context.colors.baseBgPrimary
                                  : Colors.transparent,
                              leading: Bag24BackButton(onPressed: () => context.goNamed(Routes.orders.name)),
                              actions: [OrderOptionsButton(order: order)],
                              title: _isSliverAppBarExpanded
                                  ? Text(
                                      '${context.l10n.order} №${order.id.substring(0, 6).toUpperCase()}',
                                      style: context.textStyles.bodyEmphasized,
                                    )
                                  : null,
                              flexibleSpace: FlexibleSpaceBar(
                                titlePadding: EdgeInsets.zero,
                                background: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: SafeArea(
                                    bottom: false,
                                    child: Column(
                                      children: [
                                        // tool bar height
                                        const SizedBox(height: 56),
                                        const ServiceBadgeWidget(type: ServiceBadgeType.luggageStorage),
                                        const SizedBox(height: 16),
                                        Text(
                                          '${context.l10n.order} №${order.id.substring(0, 6).toUpperCase()}',
                                          style: context.textStyles.title1Emphasized.copyWith(
                                            color: context.colors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        IconWithDescriptionTile(
                                          icon: Assets.svg.location.path,
                                          text: order.storage.fullName,
                                          textAlign: TextAlign.center,
                                        ),
                                        if (order.shouldShowQrCodeWithDescription()) ...[
                                          const SizedBox(height: 24),
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(maxWidth: compactMaxWidth),
                                            child: ShowQrButton(
                                              orderId: order.id,
                                              orderStatus: order.status,
                                              luggageIds: _selectedLuggage.value.map((e) => e.id).toList(),
                                              needPay:
                                                  _selectedLuggage.value.fold(0, (cost, e) => cost + e.amountToPay) > 0,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SliverList(
                          delegate: SliverChildListDelegate([
                            const _OrderStatusWidget(),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<Set<OrderLuggage>>(
                              valueListenable: _selectedLuggage,
                              builder: (context, selectedLuggage, _) {
                                return _OrderCompositionWidget(
                                  selectedLuggage: _selectedLuggage,
                                  onAddLuggage: (luggage) {
                                    context.read<OrderCompositionBloc>().add(OrderCompositionEvent.add(luggage));
                                  },
                                  onEditLuggage: (luggage) {
                                    context.read<OrderCompositionBloc>().add(OrderCompositionEvent.edit(luggage));
                                  },
                                  onRemoveLuggage: (id) {
                                    context.read<OrderCompositionBloc>().add(OrderCompositionEvent.remove(id));
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            const _OrderInfoWidget(),
                            const SizedBox(height: 8),
                            OrderPaymentsWidget(
                              title: order.status == OrderStatus.created ? context.l10n.amountDue : context.l10n.paid,
                              costOfLuggageStorage: order.calculateCostPerDay(),
                              discount: order.calculateDiscount(),
                              additionalPayment:
                                  order.status == OrderStatus.deposited ||
                                      order.status == OrderStatus.partiallyWithdrawn
                                  ? order.calculateAmountToPay()
                                  : 0,
                              paidAmount: order.calculatePaidAmount(),
                              additionalServicesTotal: order.calculateAdditionalServicesTotal(),
                              miles: order.milesAmount,
                              useMiles: order.milesAmount != 0,
                            ),
                            SizedBox(height: MediaQuery.paddingOf(context).bottom + 90),
                          ]),
                        ),
                      ],
                    ),
                    ValueListenableBuilder<Set<OrderLuggage>>(
                      valueListenable: _selectedLuggage,
                      builder: (context, selectedLuggage, _) {
                        return _BottomButtonWidget(selectedLuggage: selectedLuggage);
                      },
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class const _OrderStatusWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailBloc, OrderDetailState>(
      builder: (context, state) {
        final OrderDetail order = state.order!;
        final bool needAdditionalPayment = order.calculateAmountToPay() > 0;
        final bool showProgress =
            !needAdditionalPayment &&
            order.status == OrderStatus.deposited &&
            order.areAllLuggageSpecialOfferIdsTheSame();
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.baseBgPrimary,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.orderStatus, style: context.textStyles.title3Emphasized),
                const SizedBox(height: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: order.status != OrderStatus.deleted
                      ? [
                          _OrderStatusItem(
                            title: context.l10n.orderHasBeenPlaced,
                            description: DateFormat('dd.MM.yyyy, HH:mm').format(order.createdAt),
                            needAdditionalPayment: needAdditionalPayment,
                            orderStatus: order.status,
                            stepStatus: switch (order.status) {
                              OrderStatus.pending ||
                              OrderStatus.created ||
                              OrderStatus.declined ||
                              OrderStatus.paying => OrderStepStatus.active,
                              OrderStatus.deleted ||
                              OrderStatus.paid ||
                              OrderStatus.depositing ||
                              OrderStatus.deposited ||
                              OrderStatus.withdrawing ||
                              OrderStatus.partiallyWithdrawn ||
                              OrderStatus.withdrawn => OrderStepStatus.done,
                            },
                          ),
                          _OrderStatusItem(
                            title: context.l10n.placedInStorage,
                            description: order.depositedAt != null
                                ? DateFormat('dd.MM.yyyy, HH:mm').format(order.depositedAt!)
                                : null,
                            needAdditionalPayment: needAdditionalPayment,
                            orderStatus: order.status,
                            showProgress: showProgress,
                            stepStatus: switch (order.status) {
                              OrderStatus.pending ||
                              OrderStatus.created ||
                              OrderStatus.declined ||
                              OrderStatus.deleted ||
                              OrderStatus.paying => OrderStepStatus.inactive,
                              OrderStatus.paid || OrderStatus.depositing => OrderStepStatus.active,
                              OrderStatus.deposited =>
                                needAdditionalPayment ? OrderStepStatus.active : OrderStepStatus.done,
                              OrderStatus.withdrawing ||
                              OrderStatus.partiallyWithdrawn ||
                              OrderStatus.withdrawn => OrderStepStatus.done,
                            },
                            depositedAt: order.depositedAt,
                            depositedDays: order.luggage.first.specialOffer?.days,
                          ),
                          _OrderStatusItem(
                            title: order.status == OrderStatus.partiallyWithdrawn
                                ? context.l10n.partiallyIssued
                                : context.l10n.orderHasBeenIssued,
                            needAdditionalPayment: needAdditionalPayment,
                            orderStatus: order.status,
                            stepStatus: switch (order.status) {
                              OrderStatus.pending ||
                              OrderStatus.created ||
                              OrderStatus.declined ||
                              OrderStatus.deleted ||
                              OrderStatus.paying ||
                              OrderStatus.paid ||
                              OrderStatus.depositing ||
                              OrderStatus.deposited => OrderStepStatus.inactive,
                              OrderStatus.partiallyWithdrawn || OrderStatus.withdrawing => OrderStepStatus.active,
                              OrderStatus.withdrawn => OrderStepStatus.done,
                            },
                            depositedAt: order.depositedAt,
                            depositedDays: order.luggage.first.specialOffer?.days,
                            isLast: true,
                          ),
                        ]
                      : [
                          _OrderStatusItem(
                            title: context.l10n.orderCanceled,
                            description: context.l10n.youDecidedOrderCancellation,
                            orderStatus: order.status,
                            stepStatus: OrderStepStatus.error,
                            isLast: true,
                          ),
                        ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class const _OrderCompositionWidget({
  required final ValueNotifier<Set<OrderLuggage>> selectedLuggage,
  required final ValueChanged<LuggageItemModel> onAddLuggage,
  required final ValueChanged<LuggageItemModel> onEditLuggage,
  required final ValueChanged<String> onRemoveLuggage,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailBloc, OrderDetailState>(
      builder: (context, state) {
        final OrderDetail order = state.order!;
        final Iterable<OrderLuggage> noWithdrawnItems = order.noWithdrawnLuggage();
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
                Row(
                  children: [
                    Text(context.l10n.orderContent, style: context.textStyles.title3Emphasized),
                    const SizedBox(width: 8),
                    if (order.status == OrderStatus.withdrawn || order.status == OrderStatus.deleted)
                      Text(
                        '${order.luggage.length}/${order.luggage.length}',
                        style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textSecondary),
                      )
                    else
                      Text(
                        '${noWithdrawnItems.length}'
                        '/${order.status == OrderStatus.created ? 10 : order.luggage.length}',
                        style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textSecondary),
                      ),
                    const Spacer(),
                    if ((order.status == OrderStatus.deposited || order.status == OrderStatus.partiallyWithdrawn) &&
                        order.luggage.length > 1)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (selectedLuggage.value.length != noWithdrawnItems.length) {
                            selectedLuggage.value = Set.of(noWithdrawnItems);
                          } else {
                            selectedLuggage.value = {};
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              context.l10n.selectAll,
                              style: context.textStyles.subheadlineRegular.copyWith(
                                color: context.colors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 6),
                            RoundCheckbox(
                              value: selectedLuggage.value.length == noWithdrawnItems.length,
                              onChanged: (_) {
                                if (selectedLuggage.value.length != noWithdrawnItems.length) {
                                  selectedLuggage.value = Set.of(noWithdrawnItems);
                                } else {
                                  selectedLuggage.value = {};
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                SlidableAutoCloseBehavior(
                  child: _LuggageItems(
                    order: order,
                    rates: state.rates,
                    selectedLuggage: selectedLuggage,
                    onEditLuggage: onEditLuggage,
                    onRemoveLuggage: onRemoveLuggage,
                  ),
                ),
                if (order.status == OrderStatus.created && order.luggage.length < 10) ...[
                  const SizedBox(height: 12),
                  CustomTonalButton(
                    onPressed: () async {
                      final LuggageItemModel? item = await showAddLuggageBottomSheet(context, rates: state.rates);
                      if (item != null) {
                        onAddLuggage.call(item);
                      }
                    },
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class const _OrderInfoWidget() extends StatefulWidget {
  @override
  State<_OrderInfoWidget> createState() => _OrderInfoWidgetState();
}

class _OrderInfoWidgetState() extends State<_OrderInfoWidget> {
  late bool _isAutoCharge;

  @override
  void initState() {
    super.initState();
    final OrderDetailBloc bloc = context.read<OrderDetailBloc>();
    _isAutoCharge = bloc.state.order?.autoCharge ?? false;
  }

  void _showSnack(BuildContext context, {required bool isAutoCharge}) {
    if (isAutoCharge) {
      showSuccessMessage(context, context.l10n.autoBookingEnabled);
    } else {
      showErrorMessage(context, context.l10n.autoBookingDisabled);
    }
  }

  @override
  Widget build(BuildContext context) {
    final divider = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: context.colors.borderPrimary, thickness: 1, height: 1),
    );
    return BlocConsumer<OrderDetailBloc, OrderDetailState>(
      listener: (context, state) {
        setState(() => _isAutoCharge = state.order?.autoCharge ?? false);
      },
      builder: (context, state) {
        final OrderDetail order = state.order!;
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
                Text(context.l10n.orderDetails, style: context.textStyles.title3Emphasized),
                const SizedBox(height: 16),
                _TitleWithText(title: context.l10n.address, text: order.storage.fullName),
                if (order.paymentMethod != null) ...[
                  divider,
                  _TitleWithText(title: context.l10n.paymentMethod, text: order.paymentMethod!.localizedText(context)),
                  // 1. Кнопка автосписание должна появиться только после успешной оплаты привязанной картой
                  // с включённой функцией автосписания.
                  // 2. Далее ее можно выключить в статусе, начиная с "Оплачен".
                  // 3. Если пользователь самостоятельно отключил функцию автооплаты или не включил ее
                  // при первой оплате - убираем данный пункт из карточки заказа.
                  // 4. Включить автооплату можно только в статусе PAID.
                  // 5. Если нет привязанных карт - прячем
                  if (state.isCardsAvailable &&
                      (order.paymentMethod == PaymentMethodType.binding || order.bindingId != null) &&
                      (order.status == OrderStatus.paid ||
                          order.status == OrderStatus.deposited ||
                          order.status == OrderStatus.partiallyWithdrawn) &&
                      (order.autoCharge || (!order.autoCharge && order.status == OrderStatus.paid))) ...[
                    divider,
                    Row(
                      children: [
                        Expanded(
                          child: _TitleWithText(title: context.l10n.autoBooking, text: context.l10n.autoBookingAdvice),
                        ),
                        CupertinoSwitch(
                          value: _isAutoCharge,
                          onChanged: (value) async {
                            if (value) {
                              context.read<OrderDetailBloc>().add(
                                const OrderDetailEvent.changeAutoCharge(isAutoCharge: true),
                              );
                            } else {
                              final bool? result = await showCustomAlertDialog(
                                context: context,
                                title: context.l10n.disableAutoBookingQuestion,
                                content: context.l10n.disableAutoBookingDescription,
                                cancelText: context.l10n.keepCard,
                                actionText: context.l10n.disable,
                                action: () => context.read<OrderDetailBloc>().add(
                                  const OrderDetailEvent.changeAutoCharge(isAutoCharge: false),
                                ),
                                actionTextColor: context.colors.error,
                                actionButtonColor: context.colors.errorLight,
                              );
                              if (result == null || !result) {
                                return;
                              }
                            }
                            setState(() => _isAutoCharge = value);
                            if (context.mounted) {
                              _showSnack(context, isAutoCharge: value);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ],
                divider,
                _TitleWithText(
                  title: context.l10n.dateAndTime,
                  text: DateFormat('dd.MM.yyyy, HH:mm').format(order.dateOfChangeWithTimeZone),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class const _OrderStatusItem({
  required final String title,
  required final OrderStatus orderStatus,
  required final OrderStepStatus stepStatus,
  final bool needAdditionalPayment = false,
  final String? description,
  final DateTime? depositedAt,
  final int? depositedDays,
  final bool isLast = false,
  final bool showProgress = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(6),
              child: SizedBox(
                height: 20,
                width: 20,
                child: Material(
                  shape: CircleBorder(
                    side: switch (stepStatus) {
                      OrderStepStatus.inactive => BorderSide(width: 2, color: context.colors.borderPrimary),
                      _ => BorderSide.none,
                    },
                  ),
                  color: switch (stepStatus) {
                    OrderStepStatus.done => context.colors.iconAccent,
                    OrderStepStatus.error => context.colors.error,
                    _ => Colors.transparent,
                  },
                  child: Center(
                    child: switch (stepStatus) {
                      OrderStepStatus.done => const Icon(Icons.check, size: 16, color: Colors.white),
                      OrderStepStatus.error => const Icon(Icons.close, size: 16, color: Colors.white),
                      OrderStepStatus.active => const CustomLoadingSpinner(diameter: 16, strokeWidth: 4),
                      OrderStepStatus.inactive => const SizedBox.shrink(),
                    },
                  ),
                ),
              ),
            ),
            if (!isLast)
              _ControlStep(height: description != null ? 36 : 26, isActive: stepStatus == OrderStepStatus.done),
          ],
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textStyles.calloutEmphasized.copyWith(
                      color: stepStatus == OrderStepStatus.inactive
                          ? context.colors.textTertiary
                          : context.colors.textPrimary,
                    ),
                  ),
                  if (stepStatus == OrderStepStatus.active) ...[
                    const SizedBox(width: 4),
                    OrderStatusBadge(
                      text: _getPaymentStatus(context),
                      textColor: _textColorByOrderStatus(context),
                      color: _colorByOrderStatus(context),
                    ),
                  ],
                ],
              ),
              if (showProgress) ...[
                const SizedBox(height: 4),
                StorageTimeWidget(depositedDays: depositedDays, depositedAt: depositedAt),
              ] else if (description != null) ...[
                const SizedBox(height: 4),
                Text(
                  description!,
                  style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textTertiary),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _getPaymentStatus(BuildContext context) => switch (orderStatus) {
    OrderStatus.pending || OrderStatus.created || OrderStatus.declined => context.l10n.notPaidFor,
    OrderStatus.paying => context.l10n.paymentNotCompleted,
    OrderStatus.paid => context.l10n.paid,
    OrderStatus.depositing => context.l10n.inProcessing,
    OrderStatus.deposited ||
    OrderStatus.partiallyWithdrawn ||
    OrderStatus.withdrawing => needAdditionalPayment ? context.l10n.additionalPaymentIsRequired : context.l10n.paid,
    OrderStatus.withdrawn => context.l10n.issuedSingle,
    OrderStatus.deleted => context.l10n.cancelled,
  };

  Color _textColorByOrderStatus(BuildContext context) => switch (orderStatus) {
    OrderStatus.pending || OrderStatus.created || OrderStatus.declined || OrderStatus.paying => context.colors.warning,
    OrderStatus.paid ||
    OrderStatus.depositing ||
    OrderStatus.deposited ||
    OrderStatus.withdrawing ||
    OrderStatus.partiallyWithdrawn => needAdditionalPayment ? context.colors.warning : context.colors.success,
    OrderStatus.withdrawn => context.colors.success,
    OrderStatus.deleted => context.colors.error,
  };

  Color _colorByOrderStatus(BuildContext context) => switch (orderStatus) {
    OrderStatus.pending ||
    OrderStatus.created ||
    OrderStatus.declined ||
    OrderStatus.paying => context.colors.warningLight,
    OrderStatus.paid ||
    OrderStatus.depositing ||
    OrderStatus.deposited ||
    OrderStatus.withdrawing ||
    OrderStatus.withdrawn ||
    OrderStatus.partiallyWithdrawn => needAdditionalPayment ? context.colors.warningLight : context.colors.successLight,
    OrderStatus.deleted => context.colors.errorLight,
  };
}

class const _ControlStep({required final double height, required final bool isActive}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2,
      height: height,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: isActive ? context.colors.iconAccent : context.colors.borderPrimary,
        ),
      ),
    );
  }
}

class const _BottomButtonWidget({required final Set<OrderLuggage> selectedLuggage}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderDetailBloc, OrderDetailState>(
      builder: (context, state) {
        final OrderDetail? order = state.order;
        if (order == null) {
          return const SizedBox.shrink();
        }
        return switch (order.status) {
          OrderStatus.pending ||
          OrderStatus.depositing ||
          OrderStatus.withdrawing ||
          OrderStatus.declined ||
          OrderStatus.deleted => const SizedBox.shrink(),
          OrderStatus.created => PinnedBottomWidget(
            child: GradientElevatedButton(
              onPressed: order.autoCharge && order.bindingId != null
                  ? null
                  : () async => await context.pushNamed(
                      Routes.chooseWhereToPay.name,
                      queryParameters: {
                        'orderId': order.id,
                        'orderStatus': order.status.json,
                        'costPerDay': order.calculateCostPerDay().toString(),
                        'discount': order.calculateDiscount().toString(),
                        'amountToPay': order.calculateAmountToPay().toString(),
                        'luggageIds': order.luggage.map((item) => item.id).join('|'),
                      },
                    ),
              text: context.l10n.payOnline,
            ),
          ),
          OrderStatus.paying => PinnedBottomWidget(
            child: GradientElevatedButton(
              onPressed: () async => await context.pushNamed(
                Routes.chooseWhereToPay.name,
                queryParameters: {
                  'orderId': order.id,
                  'orderStatus': order.status.json,
                  'costPerDay': order.calculateCostPerDay().toString(),
                  'discount': order.calculateDiscount().toString(),
                  'amountToPay': order.calculateAmountToPay().toString(),
                  'luggageIds': order.luggage.map((item) => item.id).join('|'),
                },
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.submitOrder),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    Assets.svg.scanBarcode.path,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
          ),
          OrderStatus.paid => PinnedBottomWidget(
            child: GradientElevatedButton(
              onPressed: () async => await showQRCodeBottomSheet(context, orderId: order.id, orderStatus: order.status),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(context.l10n.submitOrder),
                  const SizedBox(width: 8),
                  SvgPicture.asset(
                    Assets.svg.scanBarcode.path,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
          ),
          OrderStatus.withdrawn => PinnedBottomWidget(
            child: CustomTonalButton(
              onPressed: () {
                context.canPop() ? context.pop() : context.goNamed(Routes.orders.name);
              },
              text: context.l10n.back,
            ),
          ),
          OrderStatus.deposited || OrderStatus.partiallyWithdrawn => Builder(
            builder: (_) {
              final int price = selectedLuggage.fold(0, (cost, item) => cost + item.amountToPay);
              final List<String> luggageIds = selectedLuggage
                  .where(
                    (e) => price > 0
                        ? (e.amountToPay > 0 && e.status == OrderLuggageStatus.deposited)
                        : (e.amountToPay > 0 || e.status == OrderLuggageStatus.deposited),
                  )
                  .map((e) => e.id)
                  .toList();
              int calculateSelectedAmountToPay(List<OrderLuggage> luggage) =>
                  luggage.fold(0, (totalCost, luggageItem) => totalCost + luggageItem.amountToPay) ~/ 100;
              return PinnedBottomWidget(
                child: selectedLuggage.isEmpty
                    ? const SizedBox.shrink()
                    : GradientElevatedButton(
                        onPressed: () async {
                          if (order.autoCharge ? !order.autoCharge : price > 0) {
                            await context.pushNamed(
                              Routes.chooseWhereToPay.name,
                              queryParameters: {
                                'orderId': order.id,
                                'orderStatus': order.status.json,
                                'costPerDay': order.calculateCostPerDay().toString(),
                                'discount': order.calculateDiscount().toString(),
                                'useAutoCharge': (order.calculateAmountToPay() == 0).toString(),
                                'luggageIds': selectedLuggage.map((item) => item.id).join('|'),
                                if (order.status == OrderStatus.deposited)
                                  'amountToPay': calculateSelectedAmountToPay(
                                    selectedLuggage.isNotEmpty ? selectedLuggage.toList() : order.luggage.toList(),
                                  ).toString(),
                              },
                            );
                          } else {
                            await showQRCodeBottomSheet(
                              context,
                              orderId: order.id,
                              orderStatus: order.status,
                              luggageIds: luggageIds,
                            );
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(price > 0 && !order.autoCharge ? context.l10n.payOnline : context.l10n.pickupOrder),
                            if (!(price > 0 && !order.autoCharge)) ...[
                              const SizedBox(width: 8),
                              SvgPicture.asset(
                                Assets.svg.scanBarcode.path,
                                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                              ),
                            ],
                          ],
                        ),
                      ),
              );
            },
          ),
        };
      },
    );
  }
}

class const _TitleWithText({required final String title, required final String text}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textSecondary)),
        const SizedBox(height: 2),
        Text(text, style: context.textStyles.bodyRegular),
      ],
    );
  }
}

class const _LuggageItems({
  required final ValueNotifier<Set<OrderLuggage>> selectedLuggage,
  required final OrderDetail order,
  required final List<RateData> rates,
  required final ValueChanged<LuggageItemModel> onEditLuggage,
  required final ValueChanged<String> onRemoveLuggage,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<OrderLuggage> luggageItems = order.luggage;
    final Iterable<OrderLuggage> withdrawnItems = luggageItems.where((e) => e.status == OrderLuggageStatus.withdrawn);
    final Iterable<OrderLuggage> noWithdrawnItems = luggageItems.where((e) => e.status != OrderLuggageStatus.withdrawn);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: (order.status == OrderStatus.partiallyWithdrawn)
          ? [
              Text(context.l10n.storedInStorageRoom, style: context.textStyles.footnoteRegular),
              ..._luggageCards(context, noWithdrawnItems, needShowTimeForPayment: true),
              Text(context.l10n.issuedPlural, style: context.textStyles.footnoteRegular),
              ..._luggageCards(context, withdrawnItems),
            ]
          : _luggageCards(
              context,
              luggageItems,
              needShowTimeForPayment: !order.areAllLuggageSpecialOfferIdsTheSame() || order.calculateAmountToPay() > 0,
            ),
    );
  }

  List<Widget> _luggageCards(
    BuildContext context,
    Iterable<OrderLuggage> luggage, {
    bool needShowTimeForPayment = false,
  }) => luggage
      .map(
        (item) => LuggageCard(
          key: ValueKey(item.id),
          onPressed: () async => await showLuggageBottomSheet(context, order: item),
          image: item.photoUrl.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: item.photoUrl,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.srcOver,
                  color: item.status == OrderLuggageStatus.withdrawn && order.status == OrderStatus.partiallyWithdrawn
                      ? Colors.black54
                      : null,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Transform.scale(
                    scale: 0.5,
                    child: CircularProgressIndicator.adaptive(value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image.file(
                  File(item.photoUrl),
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  colorBlendMode: BlendMode.srcOver,
                  color: item.status == OrderLuggageStatus.withdrawn && order.status == OrderStatus.partiallyWithdrawn
                      ? Colors.black54
                      : null,
                ),
          rate: item.rate,
          luggageStatus: item.status,
          specialOffer: item.specialOffer,
          needShowTimeForPayment:
              item.amountToPay == 0 && needShowTimeForPayment && item.status == OrderLuggageStatus.deposited,
          needPayment: item.amountToPay > 0,
          depositedAt: order.depositedAt,
          depositedDays: item.specialOffer?.days != null ? item.specialOffer!.days : null,
          onEdit: order.status == OrderStatus.created
              ? () async {
                  final LuggageItemModel? result = await showAddLuggageBottomSheet(
                    context,
                    rates: rates,
                    luggage: LuggageItemModel(
                      photo: item.photoUrl,
                      rateId: item.rate.id,
                      specialOfferId: item.specialOffer?.id,
                      needAdditionalLuggage: false,
                    ),
                  );
                  if (result == null) {
                    return;
                  }
                  final String photoId = result.photo.startsWith('https') ? item.photoId : result.photo;
                  onEditLuggage.call(result.copyWith(id: item.id, photoId: photoId));
                }
              : null,
          onDelete: order.status == OrderStatus.created && luggage.length > 1
              ? () async {
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
                  onRemoveLuggage.call(item.id);
                }
              : null,
          rightContent: switch (item.status) {
            OrderLuggageStatus.created => order.status != OrderStatus.created ? const SizedBox.shrink() : null,
            OrderLuggageStatus.withdrawn || OrderLuggageStatus.deleted => const SizedBox.shrink(),
            OrderLuggageStatus.deposited =>
              order.status == OrderStatus.withdrawing || order.luggage.length <= 1
                  ? const SizedBox.shrink()
                  : RoundCheckbox(
                      value: selectedLuggage.value.contains(item),
                      onChanged: (_) {
                        if (!selectedLuggage.value.contains(item)) {
                          selectedLuggage.value = {...selectedLuggage.value, item};
                        } else {
                          selectedLuggage.value = Set.of(selectedLuggage.value)..removeWhere((e) => e.id == item.id);
                        }
                      },
                    ),
          },
        ),
      )
      .toList();
}
