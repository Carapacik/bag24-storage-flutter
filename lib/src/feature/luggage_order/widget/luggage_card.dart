import 'package:bag24/src/core/constant/generated/assets.gen.dart';
import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';
import 'package:bag24/src/feature/luggage_order/model/rent_price.dart';
import 'package:bag24/src/feature/luggage_order/model/special_offer.dart';
import 'package:bag24/src/feature/luggage_order/widget/base_luggage_rent_widget.dart';
import 'package:bag24/src/feature/order/model/order_luggage.dart';
import 'package:bag24/src/feature/order/widget/storage_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const LuggageCard({
  required super.key,
  required final Widget image,
  required final RateData rate,
  final SpecialOffer? specialOffer,
  final OrderLuggageStatus luggageStatus = OrderLuggageStatus.created,
  final Widget? rightContent,
  final bool needShowTimeForPayment = false,
  final bool needPayment = false,
  final bool needShowDemonstration = false,
  final int? depositedDays,
  final DateTime? depositedAt,
  final VoidCallback? onDelete,
  final VoidCallback? onEdit,
  final VoidCallback? onPressed,
}) extends StatefulWidget {
  @override
  State<LuggageCard> createState() => _LuggageCardState();
}

class _LuggageCardState() extends State<LuggageCard> with SingleTickerProviderStateMixin {
  late final SlidableController _slidableController = SlidableController(this);
  static const _delay = Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();
    if (widget.needShowDemonstration) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future<void>.delayed(_delay);
        await _slidableController.openEndActionPane(duration: _delay);
        await Future<void>.delayed(_delay);
        await _slidableController.close(duration: _delay);
      });
    }
  }

  @override
  void dispose() {
    _slidableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: widget.key,
      controller: _slidableController,
      endActionPane: widget.onDelete != null || widget.onEdit != null ? _buildActionPane(context) : null,
      child: Stack(
        children: [
          _Button(
            image: widget.image,
            title: widget.rate.title,
            luggageStatus: widget.luggageStatus,
            description: widget.rate.description,
            onPressed: widget.luggageStatus != OrderLuggageStatus.withdrawn ? widget.onPressed : null,
            rightContent: widget.rightContent,
            needShowTimeForPayment: widget.needShowTimeForPayment,
            needPayment: widget.needPayment,
            depositedDays: widget.depositedDays,
            depositedAt: widget.depositedAt,
            rentPrice: RentPrice(
              initialPrice: widget.rate.initialPrice ~/ 100,
              prolongingPrice: widget.rate.prolongingPrice ~/ 100,
              basePrice: widget.specialOffer != null ? widget.specialOffer!.basePrice ~/ 100 : null,
              days: widget.specialOffer?.days,
            ),
          ),
          if (widget.luggageStatus == OrderLuggageStatus.withdrawn)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  color: context.colors.cellBgPrimary.withAlpha(50),
                ),
              ),
            ),
        ],
      ),
    );
  }

  ActionPane _buildActionPane(BuildContext context) => ActionPane(
    extentRatio: widget.onDelete != null ? 0.3 : 0.16,
    motion: const ScrollMotion(),
    dragDismissible: false,
    children: [
      if (widget.onEdit != null)
        IconButton(
          onPressed: () async {
            widget.onEdit!();
            await _slidableController.close();
          },
          icon: SvgPicture.asset(
            Assets.svg.edit.path,
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
          ),
          style: IconButton.styleFrom(backgroundColor: context.colors.buttonBgTertiary),
        ),
      if (widget.onDelete != null)
        IconButton(
          onPressed: widget.onDelete,
          icon: SvgPicture.asset(
            Assets.svg.trash.path,
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(context.colors.error, BlendMode.srcIn),
          ),
          style: IconButton.styleFrom(backgroundColor: context.colors.errorLight),
        ),
    ],
  );
}

class const _Button({
  required final String title,
  required final OrderLuggageStatus luggageStatus,
  required final RentPrice rentPrice,
  final String description = '',
  final Widget? image,
  final Widget? rightContent,
  final bool needShowTimeForPayment = false,
  final bool needPayment = false,
  final int? depositedDays,
  final DateTime? depositedAt,
  final VoidCallback? onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      color: onPressed != null ? context.colors.buttonBgTertiary : context.colors.buttonBgTertiary,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (image != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: ClipRRect(borderRadius: BorderRadius.circular(12), child: image),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaseLuggageRentWidget(title: title, rentPrice: rentPrice),
                          if (description.isNotEmpty)
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.55,
                              child: Text(
                                description,
                                style: context.textStyles.footnoteRegular.copyWith(color: context.colors.textSecondary),
                              ),
                            ),
                          if (needShowTimeForPayment)
                            StorageTimeWidget(depositedDays: depositedDays, depositedAt: depositedAt),
                          if (needPayment && luggageStatus != OrderLuggageStatus.created) ...[
                            const SizedBox(height: 8),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width - 152,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    Assets.svg.infoCircle.path,
                                    colorFilter: ColorFilter.mode(context.colors.warning, BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      context.l10n.additionalPaymentIsRequired,
                                      style: context.textStyles.footnoteRegular.copyWith(color: context.colors.warning),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (rightContent != null)
                rightContent!
              else
                SvgPicture.asset(
                  Assets.svg.arrowRight.path,
                  colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
