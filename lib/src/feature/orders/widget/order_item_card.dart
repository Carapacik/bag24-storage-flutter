import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/order/model/order_item.dart';
import 'package:bag24/src/feature/order/model/order_luggage.dart';
import 'package:bag24/src/feature/order/model/order_status.dart';
import 'package:bag24/src/feature/order/widget/bottom_sheet/qr_code_bottom_sheet.dart';
import 'package:bag24/src/feature/order/widget/order_status_badge.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/image/image_stacked.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class const OrderItemCard({required final OrderItem order, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.baseBgPrimary,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: GestureDetector(
        onTap: () async {
          final bool navigate =
              order.status == OrderStatus.created ||
              order.status == OrderStatus.paying ||
              order.status == OrderStatus.paid ||
              order.status == OrderStatus.deposited ||
              order.status == OrderStatus.partiallyWithdrawn ||
              order.status == OrderStatus.withdrawn ||
              order.status == OrderStatus.deleted;
          if (navigate) {
            await context.pushNamed(Routes.order.name, pathParameters: {'orderId': order.id});
          } else if (context.mounted) {
            showInfoMessage(context, context.l10n.yourOrderIsBeingProcessed);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      DateFormat('d MMMM y г. в HH:mm', 'ru').format(order.dateOfChangeWithTimeZone),
                      style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textTertiary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OrderStatusBadge(
                    text: order.status.localizedText(context),
                    color: order.status.color(context),
                    textColor: order.status.textColor(context),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('№ ${order.id.substring(0, 6).toUpperCase()}', style: context.textStyles.title3Emphasized),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (order.amountToPay != 0) ...[
                    Text(
                      NumberFormat('#,##0 ₽', 'ru').format(order.amountToPay),
                      style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textSecondary),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: SizedBox(
                        height: 2,
                        width: 2,
                        child: DecoratedBox(
                          decoration: BoxDecoration(shape: BoxShape.circle, color: context.colors.textTertiary),
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    child: Text(
                      order.storage.fullName,
                      style: context.textStyles.subheadlineRegular.copyWith(color: context.colors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: context.colors.buttonBgTertiary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      OrderImageStacked(orderItems: order.luggage),
                      const Spacer(),
                      switch (order.status) {
                        OrderStatus.created when order.specialOfferPaymentAllowed => _QRButton(
                          onTap: () async => await _openQr(context),
                        ),
                        OrderStatus.paying => _QRButton(
                          onTap: () => showInfoMessage(context, context.l10n.orderPaymentRequired),
                        ),
                        OrderStatus.paid when order.specialOfferPaymentAllowed => _QRButton(
                          onTap: () async => await _openQr(context),
                        ),
                        OrderStatus.deposited when order.specialOfferPaymentAllowed => _QRButton(
                          onTap: () async => order.amountToPay == 0
                              ? _openQr(context)
                              : showInfoMessage(context, context.l10n.orderHowToGet),
                        ),
                        OrderStatus.partiallyWithdrawn when order.specialOfferPaymentAllowed => _QRButton(
                          onTap: () async => order.amountToPay == 0
                              ? _openQr(context)
                              : showInfoMessage(context, context.l10n.orderHowToGet),
                        ),
                        _ => const SizedBox.shrink(),
                      },
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openQr(BuildContext context) async => await showQRCodeBottomSheet(
    context,
    orderId: order.id,
    orderStatus: order.status,
    luggageIds: order.luggage
        .where((e) => e.status != OrderLuggageStatus.withdrawn)
        .map((luggage) => luggage.id)
        .toList(),
  );
}

class const _QRButton({required final VoidCallback onTap}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: 44,
      child: Material(
        color: context.colors.buttonBgSecondaryInverse,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: SvgPicture.asset(
              Assets.svg.qr.path,
              height: 20,
              width: 20,
              colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
