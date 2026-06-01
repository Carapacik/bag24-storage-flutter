/// Events for order canceled
enum OrderCanceledAnalyticsEvent() {
  /// Order canceled
  orderCanceled,
}

extension OrderCanceledAnalyticsEventValues on OrderCanceledAnalyticsEvent {
  String get value {
    switch (this) {
      case OrderCanceledAnalyticsEvent.orderCanceled:
        return 'order_canceled';
    }
  }
}
