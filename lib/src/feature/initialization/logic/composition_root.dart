import 'dart:async';

import 'package:bag24/src/core/components/prefs_storage/prefs_storage.dart';
import 'package:bag24/src/core/components/rest_client/authentication_interceptor.dart';
import 'package:bag24/src/core/components/secure_storage/app_secure_storage.dart';
import 'package:bag24/src/core/constant/application_config.dart';
import 'package:bag24/src/core/router/navigator_holder.dart';
import 'package:bag24/src/core/utils/analytics/analytics_interactor.dart';
import 'package:bag24/src/core/utils/error_reporter/error_reporter.dart';
import 'package:bag24/src/core/utils/error_reporter/sentry_error_reporter.dart';
import 'package:bag24/src/core/utils/logger/logger.dart';
import 'package:bag24/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:bag24/src/feature/authentication/data/authentication_repository.dart';
import 'package:bag24/src/feature/authentication/model/user.dart';
import 'package:bag24/src/feature/biometrics/data/biometrics_repository.dart';
import 'package:bag24/src/feature/home/data/home_repository.dart';
import 'package:bag24/src/feature/initialization/model/dependencies_container.dart';
import 'package:bag24/src/feature/location/data/geolocation_repository.dart';
import 'package:bag24/src/feature/location/data/location_repository.dart';
import 'package:bag24/src/feature/location/data/storage_repository.dart';
import 'package:bag24/src/feature/moa/data/moa_repository.dart';
import 'package:bag24/src/feature/onboarding/data/onboarding_repository.dart';
import 'package:bag24/src/feature/order/data/order_repository.dart';
import 'package:bag24/src/feature/payment/data/payment_repository.dart';
import 'package:bag24/src/feature/permissions/data/permissions_repository.dart';
import 'package:bag24/src/feature/pin/data/pin_repository.dart';
import 'package:bag24/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:bag24/src/feature/settings/data/app_settings_datasource.dart';
import 'package:bag24/src/feature/settings/data/app_settings_repository.dart';
import 'package:bag24/src/feature/settings/model/app_settings.dart';
import 'package:bag24/src/feature/support/data/mail_repository.dart';
import 'package:bag24/src/feature/system/data/app_state_repository.dart';
import 'package:bag24/src/feature/system/data/device_info_repository.dart';
import 'package:bag24/src/feature/user/data/user_repository.dart';
import 'package:carapacik_dio_logger/carapacik_dio_logger.dart';
import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:push_notification_service/push_service.dart';
import 'package:rest_client/account/account_client.dart';
import 'package:rest_client/rest_client.dart';
import 'package:retrofit/retrofit.dart' as retrofit;
import 'package:shared_preferences/shared_preferences.dart';

/// {@template composition_root}
/// A place where top-level dependencies are initialized.
/// {@endtemplate}
///
/// {@template composition_process}
/// Composition of dependencies is a process of creating and configuring
/// instances of classes that are required for the application to work.
/// {@endtemplate}
final class const CompositionRoot({
  /// Application configuration.
  required final ApplicationConfig config,

  /// Logger used to log information during composition process.
  required final Logger logger,

  /// Error tracking manager used to track errors in the application.
  required final ErrorReporter errorReporter,
}) {
  /// {@macro composition_root}
  this;

  /// Composes dependencies and returns the result of composition.
  Future<CompositionResult> compose() async {
    final Stopwatch stopwatch = clock.stopwatch()..start();

    logger.info('Initializing dependencies...');

    // Create the dependencies container using functions.
    final DependenciesContainer dependencies = await createDependenciesContainer(config, logger, errorReporter);

    stopwatch.stop();
    logger.info('Dependencies initialized successfully in ${stopwatch.elapsedMilliseconds} ms.');

    return CompositionResult(dependencies: dependencies, millisecondsSpent: stopwatch.elapsedMilliseconds);
  }
}

/// {@template composition_result}
/// Result of composition.
///
/// {@macro composition_process}
/// {@endtemplate}
final class const CompositionResult({
  /// The dependencies container.
  required final DependenciesContainer dependencies,

  /// The number of milliseconds spent composing dependencies.
  required final int millisecondsSpent,
}) {
  /// {@macro composition_result}
  this;

  @override
  String toString() =>
      'CompositionResult('
      'dependencies: $dependencies, '
      'millisecondsSpent: $millisecondsSpent'
      ')';
}

/// Creates the full dependencies container.
Future<DependenciesContainer> createDependenciesContainer(
  ApplicationConfig config,
  Logger logger,
  ErrorReporter errorReporter,
) async {
  // Create or obtain the shared preferences instance.
  final sharedPreferences = SharedPreferencesAsync();
  final prefsStorage = PrefsStorage(sharedPreferences: sharedPreferences);
  final appSecureStorage = AppSecureStorage(
    secureStorage: const FlutterSecureStorage(
      aOptions: AndroidOptions(preferencesKeyPrefix: 'bag24-storage'),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
        accountName: 'flutter_secure_storage_service_bag24_storage',
      ),
    ),
  );

  // Get package info.
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  // Create the AppSettingsBloc using shared preferences.
  final AppSettingsBloc appSettingsBloc = await createAppSettingsBloc(sharedPreferences);

  // Init push notification
  final pushNotificationProvider = PushNotificationService();
  await pushNotificationProvider.initialize(config.environment.value);

  // Init analytics
  final analyticsInteractor = AnalyticsInteractor();
  await analyticsInteractor.initialize(appMetricaKey: config.appMetricaKey);

  // network
  final httpClient = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 60),
      preserveHeaderCase: true,
      baseUrl: config.apiUrl,
    ),
  );
  httpClient.interceptors.addAll([
    if (kDebugMode) const CarapacikDioLogger(requestHeader: false, responseHeader: false, showCurl: false),
  ]);
  final restClient = RestClient(dio: httpClient, baseUrl: config.apiUrl);

  // Authentication
  // Start
  final User seededUser = await appSecureStorage.authenticationDataSource.getUser();
  final IAuthenticationRepository authenticationRepository = AuthenticationRepository(
    authenticationClient: restClient.account,
    authenticationDataSource: appSecureStorage.authenticationDataSource,
    seedValue: seededUser,
    clearStorages: () async {
      await [prefsStorage.remove(), appSecureStorage.remove()].wait;
    },
  );

  httpClient.interceptors.add(
    AuthenticationInterceptor<InterceptorTokens>(
      getTokens: () async => authenticationRepository.currentUser.mapOrNull(
        authenticated: (user) => InterceptorTokens(access: user.accessToken, refresh: user.refreshToken),
      ),
      expireTokens: () async => await authenticationRepository.signOut(),
      setTokens: (data) async => await authenticationRepository.updateUser(
        User.authenticated(accessToken: data.access, refreshToken: data.refresh),
      ),
      refreshTokens: (dio) async => await AccountClient(dio).refresh().then(
        (response) => retrofit.HttpResponse(
          InterceptorTokens(access: response.data.result.access, refresh: response.data.result.refresh),
          response.response,
        ),
      ),
      pathsToRefresh: ['/accounts/token/refresh', '/accounts/auth/me/logout'],
      connectionError: NavigatorHolder.showServerErrorScreen,
    ),
  );

  final authenticationBloc = AuthenticationBloc(
    authenticationRepository: authenticationRepository,
    initialState: AuthenticationState.idle(seededUser),
  );
  // Authentication
  // End

  final IUserRepository userRepository = UserRepository(
    userClient: restClient.user,
    userDataSource: prefsStorage.userDataSource,
  );

  // init location
  final ILocationRepository locationRepository = LocationRepository(locationsClient: restClient.locations);
  final IStorageRepository storageRepository = StorageRepository(storageClient: restClient.storage);

  final IMailRepository mailRepository = MailRepository(
    environment: config.environment,
    mailSupportEmail: config.mailSupportEmail,
    mailClientEmail: config.mailClientEmail,
    mailClientPassword: config.mailClientPassword,
  );

  return DependenciesContainer(
    logger: logger,
    config: config,
    packageInfo: packageInfo,
    errorReporter: errorReporter,
    appSettingsBloc: appSettingsBloc,
    authenticationBloc: authenticationBloc,
    authenticationRepository: authenticationRepository,
    onboardingRepository: OnboardingRepository(onboardingDataSource: prefsStorage.onboardingDataSource),
    userRepository: userRepository,
    locationRepository: locationRepository,
    storageRepository: storageRepository,
    paymentRepository: PaymentRepository(orderClient: restClient.order, paymentClient: restClient.payment),
    orderRepository: OrderRepository(
      orderClient: restClient.order,
      fileStorageClient: restClient.fileStorage,
      photoRulesDataSource: prefsStorage.photoRulesDataSource,
    ),
    permissionsRepository: PermissionsRepository(permissionsDataSource: prefsStorage.permissionsDataSource),
    moaRepository: MOARepository(userClient: restClient.user, moaDataSource: prefsStorage.moaDataSource),
    biometricsRepository: BiometricsRepository(
      biometricsDataSource: prefsStorage.biometricsDataSource,
      localAuthentication: LocalAuthentication(),
    ),
    pinRepository: PinRepository(pinDataSource: appSecureStorage.pinDataSource),
    geolocationRepository: GeolocationRepository(geolocator: GeolocatorPlatform.instance),
    deviceInfoRepository: const DeviceInfoRepository(),
    mailRepository: mailRepository,
    homeRepository: HomeRepository(bannersClient: restClient.banners),
    appStateRepository: AppStateRepository(stateClient: restClient.state),
    pushNotificationProvider: pushNotificationProvider,
    analytics: analyticsInteractor,
  );
}

/// Creates an instance of [Logger] and attaches any provided observers.
Logger createAppLogger({List<LogObserver> observers = const []}) {
  final logger = Logger();

  for (final observer in observers) {
    logger.addObserver(observer);
  }

  return logger;
}

/// Creates an instance of [ErrorReporter] (using Sentry) and initializes it if needed.
Future<ErrorReporter> createErrorReporter(ApplicationConfig config) async {
  final errorReporter = SentryErrorReporter(sentryDsn: config.sentryDsn, environment: config.environment.value);

  if (config.sentryDsn.isNotEmpty) {
    await errorReporter.initialize();
  }

  return errorReporter;
}

/// Creates an instance of [AppSettingsBloc].
///
/// The [AppSettingsBloc] is initialized at startup to load the app settings from local storage.
Future<AppSettingsBloc> createAppSettingsBloc(SharedPreferencesAsync sharedPreferences) async {
  final appSettingsRepository = AppSettingsRepositoryImpl(
    datasource: AppSettingsDatasourceImpl(sharedPreferences: sharedPreferences),
  );

  final AppSettings? appSettings = await appSettingsRepository.getAppSettings();
  final initialState = AppSettingsState.idle(appSettings: appSettings);

  return AppSettingsBloc(appSettingsRepository: appSettingsRepository, initialState: initialState);
}
