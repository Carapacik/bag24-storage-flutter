import 'dart:async';

import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/order/bloc/transfer_order/transfer_order_bloc.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:bag24/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';

Future<void> showQRCodeBottomSheet(
  BuildContext context, {
  required String orderId,
  required OrderStatus orderStatus,
  List<String> luggageIds = const [],
  bool isPayInLuggageStorage = false,
}) async {
  final Future<void> showBottomSheet = showCustomModalBottomSheet<void>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    padding: const EdgeInsets.all(16),
    builder: (context) => BlocProvider(
      create: (context) => TransferOrderBloc(
        orderRepository: context.dependencies.orderRepository,
        orderId: orderId,
        orderStatus: orderStatus,
        luggageIds: luggageIds,
      ),
      child: _QrCodeContent(orderId: orderId, orderStatus: orderStatus, isPayInLuggageStorage: isPayInLuggageStorage),
    ),
  );
  await ScreenBrightness().setApplicationScreenBrightness(1);
  await showBottomSheet;
  await ScreenBrightness().resetApplicationScreenBrightness();
}

class const _QrCodeContent({
  required final String orderId,
  required final OrderStatus orderStatus,
  final bool isPayInLuggageStorage = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double dimension = WindowSizeScope.of(context).maybeMap(compact: () => 220.0, orElse: () => 350.0);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: BlocBuilder<TransferOrderBloc, TransferOrderState>(
              builder: (context, state) {
                if (state.inProgress || state.qr.isEmpty) {
                  return Shimmer(
                    child: ShimmerLoading(inProgress: true, child: SizedBox.square(dimension: dimension)),
                  );
                }
                return QrImageView(
                  data: state.qr,
                  size: dimension,
                  eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: context.colors.iconPrimaryInverse),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: context.colors.iconPrimaryInverse,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.codeUpdatedEveryMinutes(10),
            style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textTertiary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                border: Border.all(color: context.colors.borderPrimary),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Text(
                    switch (orderStatus) {
                      OrderStatus.pending ||
                      OrderStatus.created ||
                      OrderStatus.paying => context.l10n.showQRCodeToEmployeeForPayAndDeposit,
                      OrderStatus.deleted || OrderStatus.declined || OrderStatus.withdrawn => '',
                      OrderStatus.paid || OrderStatus.depositing => context.l10n.showQRCodeToEmployeeForDeposit,
                      OrderStatus.deposited ||
                      OrderStatus.withdrawing ||
                      OrderStatus.partiallyWithdrawn => context.l10n.showQRCodeToEmployeeForPayAndWithdraw,
                    },
                    style: context.textStyles.bodyRegular,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (isPayInLuggageStorage) ...[
            SizedBox(
              width: double.infinity,
              child: CustomTonalButton(
                onPressed: () => context.goNamed(Routes.home.name),
                text: context.l10n.backToHome,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: GradientElevatedButton(
                onPressed: () async {
                  context.goNamed(Routes.orders.name);
                  await context.pushNamed(Routes.order.name, pathParameters: {'orderId': orderId});
                },
                text: context.l10n.goToOrder,
              ),
            ),
          ] else
            SizedBox(
              width: double.infinity,
              child: CustomTonalButton(onPressed: () => context.pop(), text: context.l10n.close),
            ),
        ],
      ),
    );
  }
}
