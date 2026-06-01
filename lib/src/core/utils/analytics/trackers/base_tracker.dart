import 'package:bag24/src/core/utils/analytics/analytics.dart';
import 'package:meta/meta.dart';

/// Базовый класс отправки события
abstract class BaseTracker(
  /// Экземпляр класса аналитики
  @protected final Analytics analytics,
);
