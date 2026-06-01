import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'notifications_client.g.dart';

@RestApi()
abstract class NotificationsClient {
  factory(Dio dio, {String? baseUrl}) = _NotificationsClient;

  @POST('/v1/notifications/pushes')
  Future<void> sendPush({@Field() required String title, @Field() required String body});
}
