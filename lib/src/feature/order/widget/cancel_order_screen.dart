import 'dart:async';

import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/order/bloc/cancel_order/cancel_order_bloc.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/orders/bloc/active_orders/active_orders_bloc.dart';
import 'package:bag24/src/feature/orders/bloc/inactive_orders/inactive_orders_bloc.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/round_checkbox.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:bag24/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:bag24/src/feature/shared_widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class const CancelOrderScreen({required final String orderId, required final OrderStatus status, super.key})
    extends StatefulWidget {
  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState() extends State<CancelOrderScreen> {
  late final _commentController = TextEditingController();
  late final List<String> reasons;
  int? _selectedReasonIndex;

  @override
  void initState() {
    super.initState();
    reasons = [
      context.l10n.wrongPaymentMethod,
      context.l10n.willChangeOrderAndPlaceAgain,
      context.l10n.notSatisfiedWithPriceAndTariff,
      context.l10n.notSatisfiedWithStorageRoom,
      context.l10n.foundAnotherOption,
      context.l10n.changedMindAboutBuying,
      context.l10n.anotherReason,
    ];
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _cancelHandler(BuildContext context) {
    if (_selectedReasonIndex == null) {
      return;
    }
    String reason;
    if (_commentController.text.isNotEmpty && _selectedReasonIndex == reasons.length - 1) {
      reason = _commentController.text.trim();
    } else {
      reason = reasons[_selectedReasonIndex!];
    }
    unawaited(context.dependencies.analytics.orderCanceledTracker.orderCanceled(reason));
    context.read<CancelOrderBloc>().add(const CancelOrderEvent.cancel());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CancelOrderBloc, CancelOrderState>(
      listener: (context, state) {
        state.mapOrNull(
          success: (_) {
            context.read<ActiveOrdersBloc>().add(const ActiveOrdersEvent.start());
            context.read<InactiveOrdersBloc>().add(const InactiveOrdersEvent.start());
            showErrorMessage(
              context,
              context.l10n.orderCanceled,
              widget.status == OrderStatus.paid ? context.l10n.moneyWillBeReturnedToAccount : null,
            );
            context.goNamed(Routes.orders.name);
          },
          failure: (s) => showCustomAppException(context, s.exception),
        );
      },
      builder: (context, state) => FullScreenLoading(
        inProgress: state.inProgress,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: CustomAppBar(titleText: context.l10n.cancellationOfOrder),
            body: Stack(
              fit: StackFit.expand,
              children: [
                SafeArea(
                  child: ListView(
                    padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + 90),
                    children: [
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(context.l10n.whyDecidedToCancelOrder, style: context.textStyles.title2Emphasized),
                      ),
                      const SizedBox(height: 24),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: reasons.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            setState(() => _selectedReasonIndex = index);
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          title: Text(reasons[index], style: context.textStyles.bodyRegular),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          trailing: RoundCheckbox(
                            value: index == _selectedReasonIndex,
                            onChanged: (_) {
                              setState(() => _selectedReasonIndex = index);
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                        ),
                      ),
                      AnimatedSlide(
                        offset: _selectedReasonIndex == reasons.length - 1
                            ? Offset.zero
                            : Offset(-MediaQuery.sizeOf(context).width, 0),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.easeOut,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            child: CustomTextField(
                              controller: _commentController,
                              labelText: context.l10n.describeTheProblem,
                              maxLines: 3,
                              maxLength: 500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PinnedBottomWidget(
                  child: GradientElevatedButton(
                    onPressed: _selectedReasonIndex == null ? null : () => _cancelHandler(context),
                    text: widget.status == OrderStatus.paid
                        ? context.l10n.cancelOrderAndIssueRefund
                        : context.l10n.cancelOrder,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
