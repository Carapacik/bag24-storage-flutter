import 'dart:async';

import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/show_qr_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/bottom_navigation_bar.dart';
import 'package:bag24/src/feature/shared_widgets/custom_painter/top_gradient_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class const PaymentResultScreen({
  required final String orderId,
  required final bool successResult,
  required final OrderStatus orderStatus,
  final List<String> luggageIds = const [],
  super.key,
}) extends StatelessWidget {
  Future<void> _goToOrderScreen(BuildContext context) async {
    context.goNamed(Routes.orders.name);
    await context.pushNamed(Routes.order.name, pathParameters: {'orderId': orderId});
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(size: Size(size.width, size.height), painter: TopGradientPainter()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const Spacer(),
                  Center(
                    child: SizedBox(
                      height: 72,
                      width: 72,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: successResult ? context.colors.successLight : context.colors.errorLight,
                          borderRadius: const BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            successResult ? Assets.svg.checkCircle.path : Assets.svg.cancelCircle.path,
                            height: 44,
                            width: 44,
                            colorFilter: ColorFilter.mode(
                              successResult ? context.colors.success : context.colors.error,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    successResult ? context.l10n.paymentSuccessful : context.l10n.paymentFailed,
                    style: context.textStyles.title1Emphasized,
                    textAlign: TextAlign.center,
                  ),
                  if (!successResult) ...[
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.paymentErrorMessage,
                      style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 24),
                  ShowQrButton(orderId: orderId, orderStatus: orderStatus, luggageIds: luggageIds),
                  const Spacer(),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: GestureDetector(
                onTap: () => context.goNamed(Routes.orders.name),
                child: SvgPicture.asset(
                  Assets.svg.close.path,
                  colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavigationBar(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: CustomTonalButton(
                onPressed: () async => context.goNamed(successResult ? Routes.home.name : Routes.orders.name),
                text: successResult ? context.l10n.backToHome : context.l10n.returnToOrders,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: GradientElevatedButton(
                onPressed: () async {
                  if (successResult) {
                    await _goToOrderScreen(context);
                  } else {
                    context.pop();
                  }
                },
                text: successResult ? context.l10n.viewOrder : context.l10n.retryPayment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
