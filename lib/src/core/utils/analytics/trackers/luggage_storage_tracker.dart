import 'package:bag24/src/core/utils/analytics/data/luggage_storage_booking_type.dart';
import 'package:bag24/src/core/utils/analytics/events/luggage_storage_event.dart';
import 'package:bag24/src/core/utils/analytics/trackers/base_tracker.dart';
import 'package:bag24/src/feature/location/model/storage_model.dart';

/// Tracker for luggage storage selection
class LuggageStorageTracker(super.analytics) extends BaseTracker {
  /// Send event when the pricing window is opened
  Future<void> trackLuggageStorageOpened() async {
    await analytics.logEvent(LuggageStorageAnalyticsEvent.luggageStorageOpened.value);
  }

  /// Send event when the luggage storage is selected
  Future<void> trackLuggageStorageSelected(Storage storage) async {
    await analytics.logEvent(
      LuggageStorageAnalyticsEvent.luggageStorageSelected.value,
      params: {
        'id': storage.id,
        'name':
            '${storage.location.name} (${storage.location.iata})${storage.name.isNotEmpty ? ', ${storage.name}' : ''}',
      },
    );
  }

  /// Send event when the luggage storage booking with type
  Future<void> trackLuggageStorageBooking(LuggageStorageBookingProgress type) async {
    await analytics.logEvent(LuggageStorageAnalyticsEvent.luggageStorageBooking.value, params: {'type': type.name});
  }
}
