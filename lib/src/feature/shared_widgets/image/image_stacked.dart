import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/order/model/order_luggage.dart';
import 'package:bag24/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class const OrderImageStacked({
  required final List<OrderLuggage> orderItems,
  final TextDirection direction = TextDirection.rtl,
  final double imageSize = 44.0,
  final double borderSize = 1,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const size = 44.0;
    const xShift = 8.0;

    final List<OrderLuggage> sortedOrderItems = List.of(orderItems)..sort(_compareOrderItems);
    final List<Widget> items = sortedOrderItems.map((item) => buildImage(context, item)).toList();

    return StackedWidgets(direction: direction, items: items, size: size, xShift: xShift);
  }

  int _compareOrderItems(OrderLuggage a, OrderLuggage b) {
    // If a is deposited and b is not, a comes after b
    if (a.status == OrderLuggageStatus.withdrawn && b.status != OrderLuggageStatus.withdrawn) {
      return 1;
    }
    // If b is deposited and a is not, b comes after a
    else if (b.status == OrderLuggageStatus.withdrawn && a.status != OrderLuggageStatus.withdrawn) {
      return -1;
    }
    // If both are deposited or neither is, their order doesn't matter for this sort
    else {
      return 0;
    }
  }

  Widget buildImage(BuildContext context, OrderLuggage item) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(borderSize),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                width: imageSize - borderSize * 2,
                height: imageSize - borderSize * 2,
                fit: BoxFit.cover,
                color: item.status == OrderLuggageStatus.withdrawn
                    ? context.colors.borderSecondary.withAlpha(120)
                    : null,
                colorBlendMode: BlendMode.srcOver,
                imageUrl: item.photoUrl,
                placeholder: (context, url) => Shimmer(
                  child: ShimmerLoading(
                    inProgress: true,
                    child: SizedBox(height: imageSize, width: imageSize),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            if (item.status == OrderLuggageStatus.withdrawn)
              Positioned(
                top: 12,
                left: 12,
                child: DecoratedBox(
                  decoration: ShapeDecoration(shape: const CircleBorder(), color: context.colors.borderSecondary),
                  child: const Padding(
                    padding: EdgeInsets.all(3),
                    child: Center(child: Icon(Icons.check, size: 10)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class const StackedWidgets({
  required final List<Widget> items,
  final TextDirection direction = TextDirection.ltr,
  final double size = 100,
  final double xShift = 20,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Padding> allItems = items
        .asMap()
        .map((index, item) {
          final double left = size - xShift;
          final value = Padding(
            padding: EdgeInsets.only(left: left * index),
            child: SizedBox(width: size, height: size, child: item),
          );

          return MapEntry(index, value);
        })
        .values
        .toList();

    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Stack(children: direction == TextDirection.ltr ? allItems.reversed.toList() : allItems),
      ),
    );
  }
}
