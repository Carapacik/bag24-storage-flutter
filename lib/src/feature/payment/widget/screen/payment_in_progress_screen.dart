import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/shared_widgets/button/tonal_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/bottom_navigation_bar.dart';
import 'package:bag24/src/feature/shared_widgets/custom_painter/top_gradient_painter.dart';
import 'package:bag24/src/feature/shared_widgets/loading/custom_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

// TODO(akozlov): Добавить bloc для периодической проверки статуса оплаты
class const PaymentInProgressScreen({super.key}) extends StatelessWidget {
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
                  CustomLoadingSpinner(color: context.colors.progressBar),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.waitingForPayment,
                    style: context.textStyles.title1Emphasized,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.waitingMessage,
                    style: context.textStyles.bodyRegular.copyWith(color: context.colors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
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
        child: CustomTonalButton(
          text: context.l10n.returnToOrders,
          onPressed: () async => context.goNamed(Routes.orders.name),
        ),
      ),
    );
  }
}
