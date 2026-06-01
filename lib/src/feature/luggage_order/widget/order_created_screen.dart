import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/router/routes.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/core/utils/layout/layout.dart';
import 'package:bag24/src/feature/luggage_order/bloc/order_created/order_created_bloc.dart';
import 'package:bag24/src/feature/order/model/order_detail.dart';
import 'package:bag24/src/feature/shared_widgets/base/app_bar.dart';
import 'package:bag24/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:bag24/src/feature/shared_widgets/button/gradient_button.dart';
import 'package:bag24/src/feature/shared_widgets/button/show_qr_button.dart';
import 'package:bag24/src/feature/shared_widgets/common/pinned_bottom_widget.dart';
import 'package:bag24/src/feature/shared_widgets/custom_painter/top_gradient_painter.dart';
import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class const OrderCreatedScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    return BlocBuilder<OrderCreatedBloc, OrderCreatedState>(
      builder: (context, state) {
        final OrderDetail? order = state.order;
        return Scaffold(
          backgroundColor: context.colors.baseBgSecondary,
          extendBodyBehindAppBar: true,
          appBar: CustomAppBar(
            backgroundColor: Colors.transparent,
            leading: Bag24CloseButton(onPressed: () => context.goNamed(Routes.orders.name)),
          ),
          body: Shimmer(
            child: Stack(
              children: [
                ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ClipRect(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: MediaQuery.paddingOf(context).top + 376),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.colors.baseBgPrimary,
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                          ),
                          child: Stack(
                            children: [
                              CustomPaint(size: Size(size.width, size.height), painter: TopGradientPainter()),
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, MediaQuery.paddingOf(context).top + 76, 16, 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 16),
                                    Center(
                                      child: SizedBox(
                                        height: 80,
                                        width: 80,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: context.colors.successLight,
                                            borderRadius: const BorderRadius.all(Radius.circular(24)),
                                          ),
                                          child: Center(
                                            child: SvgPicture.asset(Assets.svg.checkCircle.path, height: 48, width: 48),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(context.l10n.orderHasBeenPlaced, style: context.textStyles.title1Emphasized),
                                    const SizedBox(height: 24),
                                    if (order == null)
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: compactMaxWidth),
                                        child: const ShimmerLoading(
                                          inProgress: true,
                                          child: SizedBox(height: 112, width: double.infinity),
                                        ),
                                      )
                                    else if (order.shouldShowQrCodeWithDescription())
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: compactMaxWidth),
                                        child: ShowQrButton(orderId: order.id, orderStatus: order.status),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.colors.baseBgPrimary,
                        borderRadius: const BorderRadius.all(Radius.circular(24)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        child: _OrderInfo(order: order),
                      ),
                    ),
                  ],
                ),
                PinnedBottomWidget(
                  child: GradientElevatedButton(
                    onPressed: order == null
                        ? null
                        : () async => await context.pushNamed(
                            Routes.chooseWhereToPay.name,
                            queryParameters: {
                              'orderId': order.id,
                              'orderStatus': order.status.json,
                              'costPerDay': order.calculateCostPerDay().toString(),
                              'discount': order.calculateDiscount().toString(),
                              'amountToPay': order.calculateAmountToPay().toString(),
                              'luggageIds': order.luggage.map((luggageItem) => luggageItem.id).join('|'),
                            },
                          ),
                    text: context.l10n.payOnline,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class const _OrderInfo({required final OrderDetail? order}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.l10n.orderDetails, style: context.textStyles.title3Emphasized),
        const SizedBox(height: 16),
        _OrderInfoItem(title: context.l10n.orderNumber, value: order?.id.substring(0, 6).toUpperCase(), haveCopy: true),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Divider(color: context.colors.borderSecondary, height: 1, thickness: 1),
        ),
        _OrderInfoItem(title: context.l10n.address, value: order?.storage.fullName),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Divider(color: context.colors.borderSecondary, height: 1, thickness: 1),
        ),
        _OrderInfoItem(
          title: context.l10n.dateAndTime,
          value: order == null ? null : DateFormat('dd.MM.yyyy, HH:mm').format(DateTime.now()),
        ),
      ],
    );
  }
}

class const _OrderInfoItem({required final String title, required final String? value, final bool haveCopy = false})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: context.textStyles.subheadlineRegular16.copyWith(color: context.colors.textTertiary)),
        const SizedBox(height: 2),
        if (value == null)
          const ShimmerLoading(inProgress: true, child: SizedBox(height: 16, width: 200))
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value!, style: context.textStyles.bodyRegular),
              if (haveCopy)
                IconButton(
                  onPressed: () async {
                    showInfoMessage(context, context.l10n.copiedToClipboard);
                    await Clipboard.setData(ClipboardData(text: value!));
                  },
                  icon: SvgPicture.asset(
                    Assets.svg.copy.path,
                    height: 24,
                    width: 24,
                    colorFilter: ColorFilter.mode(context.colors.iconTertiary, BlendMode.srcIn),
                  ),
                  style: IconButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.all(2),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
