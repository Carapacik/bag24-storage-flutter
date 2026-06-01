import 'package:bag24/src/core/components/prefs_storage/permissions/permissions_data_source.dart';
import 'package:bag24/src/core/components/prefs_storage/user/user_data_source.dart';
import 'package:bag24/src/core/components/secure_storage/authentication/authentication_data_source.dart';
import 'package:bag24/src/core/components/secure_storage/pin/pin_data_source.dart';
import 'package:bag24/src/feature/authentication/data/authentication_repository.dart';
import 'package:bag24/src/feature/location/data/geolocation_repository.dart';
import 'package:bag24/src/feature/location/data/location_repository.dart';
import 'package:bag24/src/feature/location/data/storage_repository.dart';
import 'package:bag24/src/feature/moa/data/moa_repository.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bag24/src/feature/permissions/data/permissions_repository.dart';
import 'package:bag24/src/feature/pin/data/pin_repository.dart';
import 'package:bag24/src/feature/support/data/mail_repository.dart';
import 'package:bag24/src/feature/system/data/device_info_repository.dart';
import 'package:bag24/src/feature/user/data/user_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:push_notification_interface/push_interface.dart';
import 'package:rest_client/account/account_client.dart';
import 'package:rest_client/locations/dto/location_dto.dart';
import 'package:rest_client/locations/locations_client.dart';
import 'package:rest_client/result_response.dart';
import 'package:rest_client/storage/dto/storage_dto.dart';
import 'package:rest_client/storage/storage_client.dart';
import 'package:rest_client/user/user_client.dart';

@GenerateNiceMocks([
  // Repository
  MockSpec<IAuthenticationRepository>(),
  MockSpec<IUserRepository>(),
  MockSpec<IPinRepository>(),
  MockSpec<IStorageRepository>(),
  MockSpec<IPermissionsRepository>(),
  MockSpec<ILocationRepository>(),
  MockSpec<IGeolocationRepository>(),
  MockSpec<IOrderRepository>(),
  MockSpec<IDeviceInfoRepository>(),
  MockSpec<IMailRepository>(),
  MockSpec<IMOARepository>(),

  // Rest Client
  MockSpec<AccountClient>(),
  MockSpec<UserClient>(),
  MockSpec<StorageClient>(),
  MockSpec<LocationsClient>(),

  // SPrefs
  MockSpec<IAuthenticationDataSource>(),
  MockSpec<IUserDataSource>(),
  MockSpec<IPinDataSource>(),
  MockSpec<IPermissionsDataSource>(),

  // Response
  MockSpec<ResultResponse<StorageDto>>(as: #MockResponseStorageDto),
  MockSpec<ResultResponse<StorageListDto>>(as: #MockResponseStorageListDto),
  MockSpec<ResultResponse<LocationListDto>>(as: #MockResponseLocationListDto),

  // Geolocation
  MockSpec<GeolocatorPlatform>(),
  MockSpec<PackageInfo>(),

  // Provider
  MockSpec<IPushNotificationService>(),
])
export 'mock.mocks.dart';
