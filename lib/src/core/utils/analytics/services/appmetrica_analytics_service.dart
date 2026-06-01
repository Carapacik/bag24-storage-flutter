import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bag24/src/core/utils/analytics/services/base_analytics_service.dart';

/// Класс для работы с аналитикой AppMetrica
class AppMetricaAnalyticsService() implements BaseAnalyticsService {
  /// Отправить событие в сервис аналитики
  @override
  Future<void> logEvent(String name, {Map<String, dynamic>? params = BaseAnalyticsService.defaultParams}) async {
    if (params != null) {
      await AppMetrica.reportEventWithJson(name, jsonEncode(params));
    } else {
      await AppMetrica.reportEvent(name);
    }
  }

  /// Установить id пользователя
  @override
  Future<void> setUserId(String? id) async {
    await AppMetrica.setUserProfileID(id);
  }
}
