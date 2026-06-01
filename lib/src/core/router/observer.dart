import 'package:bag24/src/core/utils/logger/logger.dart';
import 'package:flutter/material.dart';

class AppRouterObserver(final Logger logger) extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      logger.info('didPush: ${route.str}, previousRoute= ${previousRoute?.str}');

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      logger.info('didPop: ${route.str}, previousRoute= ${previousRoute?.str}');

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      logger.info('didRemove: ${route.str}, previousRoute= ${previousRoute?.str}');

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      logger.info('didReplace: new= ${newRoute?.str}, old= ${oldRoute?.str}');

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) => logger.info(
    'didStartUserGesture: ${route.str}, '
    'previousRoute= ${previousRoute?.str}',
  );

  @override
  void didStopUserGesture() => logger.info('didStopUserGesture');
}

extension on Route<dynamic> {
  String get str => 'route(${settings.name}: ${settings.arguments})';
}
