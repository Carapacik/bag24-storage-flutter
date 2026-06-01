import 'dart:async';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/url_utils.dart';
import 'package:bag24/src/feature/order/bloc/cancel_order/cancel_order_bloc.dart';
import 'package:bag24/src/feature/order/bloc/order_detail/order_detail_bloc.dart';
import 'package:bag24/src/feature/order/bloc/order_receipts/order_receipts_bloc.dart';
import 'package:bag24/src/feature/order/model/order_detail.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/order/model/receipt.dart';
import 'package:bag24/src/feature/orders/bloc/active_orders/active_orders_bloc.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_actions_sheet.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:bag24/src/feature/shared_widgets/modal/dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class const OrderOptionsButton({required final OrderDetail order, super.key}) extends StatefulWidget {
  @override
  State<OrderOptionsButton> createState() => _OrderOptionsButtonState();
}

class _OrderOptionsButtonState() extends State<OrderOptionsButton> {
  late final OrderReceiptsBloc _receiptsBloc;
  late final CancelOrderBloc _cancelOrderBloc;

  @override
  void initState() {
    super.initState();
    _receiptsBloc = OrderReceiptsBloc(orderRepository: context.dependencies.orderRepository);
    _cancelOrderBloc = CancelOrderBloc(orderId: widget.order.id, orderRepository: context.dependencies.orderRepository);
  }

  @override
  void dispose() {
    unawaited(_cancelOrderBloc.close());
    unawaited(_receiptsBloc.close());
    super.dispose();
  }

  Future<void> _showPaymentReceipts(BuildContext context, List<Receipt> receipts) => showCustomModalBottomSheet(
    context: context,
    isScrollControlled: true,
    padding: const EdgeInsets.all(16),
    builder: (context) => SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.orderReceipts, style: context.textStyles.title3Emphasized),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height / 2),
            child: ListView.separated(
              itemCount: receipts.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _PaymentReceiptItem(receipt: receipts[index]),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CustomTonalButton(onPressed: () => Navigator.of(context).pop(), text: context.l10n.close),
          ),
        ],
      ),
    ),
  );

  Future<void> _showOptions(BuildContext context) => showCustomModalBottomActionsSheet<void>(
    context: context,
    title: '${context.l10n.order} №${widget.order.id.substring(0, 6).toUpperCase()}',
    actions: [
      CustomSheetAction(
        title: context.l10n.orderHelp,
        iconPath: Assets.svg.question.path,
        onTap: () async => await context.pushNamed(
          Routes.faq.name,
          queryParameters: {'airport': widget.order.storage.location.name, 'orderId': widget.order.id},
        ),
      ),
      CustomSheetAction(
        title: context.l10n.orderReceipts,
        iconPath: Assets.svg.receipt.path,
        onTap: () => _receiptsBloc.add(OrderReceiptsEvent.start(widget.order.id)),
      ),
      if (widget.order.status == OrderStatus.paying || widget.order.status == OrderStatus.paid)
        CustomSheetAction(
          title: context.l10n.issueAReturn,
          iconPath: Assets.svg.refresh.path,
          onTap: () async => await showCustomAlertDialog(
            context: context,
            title: context.l10n.doYouWantToIssueAReturn,
            content: context.l10n.doYouWantToIssueAReturnDescription,
            cancelText: context.l10n.notNow,
            actionText: context.l10n.yesIssueIt,
            action: () {
              _cancelOrderBloc.add(const CancelOrderEvent.refund());
              Navigator.of(context).pop();
            },
            actionTextColor: context.colors.error,
            actionButtonColor: context.colors.errorLight,
          ),
        ),
      if (widget.order.status == OrderStatus.created || widget.order.status == OrderStatus.paid)
        CustomSheetAction(
          title: widget.order.status == OrderStatus.paid
              ? context.l10n.cancelOrderAndIssueRefund
              : context.l10n.cancelOrder,
          iconPath: Assets.svg.closeCircle.path,
          color: context.colors.error,
          onTap: () async => await context.pushNamed(
            Routes.cancelOrder.name,
            pathParameters: {'orderId': widget.order.id},
            queryParameters: {'status': widget.order.status.json},
          ),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OrderReceiptsBloc, OrderReceiptsState>(
          bloc: _receiptsBloc,
          listener: (context, state) {
            state.mapOrNull(
              success: (s) async {
                if (s.receipts.length == 1) {
                  await UrlUtils.launchExternalUrl(context, s.receipts.first.url);
                } else if (s.receipts.isNotEmpty) {
                  await _showPaymentReceipts(context, s.receipts);
                } else {
                  showInfoMessage(context, context.l10n.sorryNoReceiptsAreAvailable);
                }
              },
              failure: (s) => showCustomAppException(context, s.exception),
            );
          },
        ),
        BlocListener<CancelOrderBloc, CancelOrderState>(
          bloc: _cancelOrderBloc,
          listener: (context, state) {
            state.mapOrNull(
              success: (_) async {
                context.read<ActiveOrdersBloc>().add(const ActiveOrdersEvent.start());
                context.read<OrderDetailBloc>().add(const OrderDetailEvent.updateStatus());
                showSuccessMessage(context, context.l10n.returnHasBeenProcessedTheMoneyWillBeReturned);
              },
              failure: (s) => showCustomAppException(context, s.exception),
            );
          },
        ),
      ],
      child: IconButton(
        onPressed: () async => await _showOptions(context),
        icon: Icon(Icons.more_horiz, size: 24, color: context.colors.iconPrimaryInverse),
      ),
    );
  }
}

class const _PaymentReceiptItem({required final Receipt receipt}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await UrlUtils.launchExternalUrl(context, receipt.url),
      behavior: HitTestBehavior.opaque,
      child: Row(
        spacing: 12,
        children: [
          SizedBox(
            height: 44,
            width: 44,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.colors.cellBgPrimary,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  Assets.svg.receipt.path,
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${receipt.total ~/ 100} ₽', style: context.textStyles.bodyRegular),
                const SizedBox(height: 2),
                Text(
                  DateFormat('dd.MM.yyyy').format(receipt.createdAt),
                  style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                ),
              ],
            ),
          ),
          SvgPicture.asset(
            Assets.svg.arrowRight.path,
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(context.colors.iconSecondary, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}
