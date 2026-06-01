import 'package:bag24/src/core/exception/app_exception.dart';
import 'package:bag24/src/core/exception/network_exception_type.dart';
import 'package:dio/dio.dart';

export 'app_exception.dart';
export 'network_exception_type.dart';

class ExceptionHandler() {
  static Future<void> handle(
    Future<void> Function() handler, {
    void Function(AppException exception, StackTrace stackTrace)? onError,
    void Function()? onDone,
  }) async {
    try {
      await handler.call();
    } on DioException catch (exception, stackStace) {
      final Object? responseData = exception.response?.data;
      String? responseMessage;
      // Specify your response message
      if (responseData is Map<String, dynamic>) {
        responseMessage = responseData['message']?.toString();
      }

      final appException = AppException.network(
        responseMessage ?? exception.error.toString(),
        statusCode: exception.response?.statusCode,
        responseData: exception.response?.data,
        networkType: NetworkExceptionType.byStatusCode(exception),
      );
      onError?.call(appException, stackStace);
      Error.throwWithStackTrace(appException, stackStace);
    } on Object catch (exception, stackStace) {
      final appException = AppException.unknown(exception.toString());
      onError?.call(appException, stackStace);
      Error.throwWithStackTrace(AppException.unknown(exception.toString()), stackStace);
    } finally {
      onDone?.call();
    }
  }
}
