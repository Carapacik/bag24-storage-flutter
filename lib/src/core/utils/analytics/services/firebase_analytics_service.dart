// import 'package:bag24/src/core/utils/analytics/services/base_analytics_service.dart';
// import 'package:firebase_analytics/firebase_analytics.dart';
//
// /// Класс для работы с аналитикой Firebase
// class FirebaseAnalyticsService implements BaseAnalyticsService {
//   /// Экземпляр аналитики Firebase
//   static final _instance = FirebaseAnalytics.instance;
//
//   /// Отправить событие в Firebase
//   @override
//   Future<void> logEvent(
//     String name, {
//     Map<String, dynamic>? params,
//   }) async {
//     await _instance.logEvent(
//       name: name,
//       parameters: params ?? BaseAnalyticsService.defaultParams,
//     );
//   }
//
//   @override
//   Future<void> setUserId(String? id) async {
//     await _instance.setUserId(id: id);
//     await _instance.setUserProperty(name: 'user_id', value: id);
//   }
// }
