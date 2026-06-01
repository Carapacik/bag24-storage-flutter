import 'package:bag24/src/core/utils/analytics/services/base_analytics_service.dart';

/// Класс для работы с аналитикой
class Analytics(
  /// Список сервисов аналитики
  final List<BaseAnalyticsService> _services,
) implements BaseAnalyticsService {
  /// Отправить событие в аналитику
  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? params}) async {
    for (final BaseAnalyticsService service in _services) {
      await service.logEvent(name, params: params);
      // logger.info(
      //   'Analytics service = ${service.runtimeType} logEvent\n'
      //   '---event = $name\n'
      //   '---params = $params',
      // );
    }
  }

  @override
  Future<void> setUserId(String? id) async {
    for (final BaseAnalyticsService service in _services) {
      await service.setUserId(id);
      // logger.info(
      //   'Analytics service = ${service.runtimeType} setUserId\n'
      //   '---userId = $id\n',
      // );
    }
  }
}
