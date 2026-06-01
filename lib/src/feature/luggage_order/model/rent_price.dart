class const RentPrice({
  required final int initialPrice,
  required final int prolongingPrice,
  final int? basePrice,
  final int? days,
}) {
  int? get oldPrice {
    if (days != null) {
      return initialPrice + (days! - 1) * prolongingPrice;
    }
    return null;
  }
}
