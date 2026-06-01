import 'package:bag24/src/core/utils/extensions/extensions.dart';
import 'package:bag24/src/feature/luggage_order/model/rate_data.dart';
import 'package:bag24/src/feature/luggage_order/model/rent_price.dart';
import 'package:bag24/src/feature/luggage_order/widget/base_luggage_rent_widget.dart';
import 'package:flutter/material.dart';

class const SpecialOfferCard({
  required final bool isSelected,
  required final String title,
  required final RateData rate,
  required final RentPrice rentPrice,
  final VoidCallback? onTap,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        side: isSelected ? BorderSide(color: context.colors.cellBorderActive) : BorderSide.none,
      ),
      color: context.colors.buttonBgTertiary,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BaseLuggageRentWidget(title: title, rentPrice: rentPrice, isSelected: isSelected, showCheckbox: true),
        ),
      ),
    );
  }
}
