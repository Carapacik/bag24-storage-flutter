import 'package:dio/dio.dart';
import 'package:rest_client/account/account_client.dart';
import 'package:rest_client/banners/banners_client.dart';
import 'package:rest_client/file_storage/file_storage_client.dart';
import 'package:rest_client/locations/locations_client.dart';
import 'package:rest_client/notifications/notifications_client.dart';
import 'package:rest_client/order/order_client.dart';
import 'package:rest_client/payment/payment_client.dart';
import 'package:rest_client/state/state_client.dart';
import 'package:rest_client/storage/storage_client.dart';
import 'package:rest_client/user/user_client.dart';

final class RestClient({required final Dio _dio, required final String _baseUrl}) {
  AccountClient? _account;
  BannersClient? _banners;
  FileStorageClient? _fileStorage;
  LocationsClient? _locations;
  NotificationsClient? _notifications;
  OrderClient? _order;
  PaymentClient? _payment;
  StateClient? _stateClient;
  StorageClient? _storage;
  UserClient? _user;

  AccountClient get account => _account ??= AccountClient(_dio, baseUrl: _baseUrl);

  BannersClient get banners => _banners ??= BannersClient(_dio, baseUrl: _baseUrl);

  FileStorageClient get fileStorage => _fileStorage ??= FileStorageClient(_dio, baseUrl: _baseUrl);

  LocationsClient get locations => _locations ??= LocationsClient(_dio, baseUrl: _baseUrl);

  NotificationsClient get notifications => _notifications ??= NotificationsClient(_dio, baseUrl: _baseUrl);

  OrderClient get order => _order ??= OrderClient(_dio, baseUrl: _baseUrl);

  PaymentClient get payment => _payment ??= PaymentClient(_dio, baseUrl: _baseUrl);

  StateClient get state => _stateClient ??= StateClient(_dio, baseUrl: _baseUrl);

  StorageClient get storage => _storage ??= StorageClient(_dio, baseUrl: _baseUrl);

  UserClient get user => _user ??= UserClient(_dio, baseUrl: _baseUrl);
}
