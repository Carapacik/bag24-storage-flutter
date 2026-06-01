import 'package:bag24/src/core/constant/application_config.dart';
import 'package:bag24/src/core/utils/analytics/analytics_interactor.dart';
import 'package:bag24/src/core/utils/error_reporter/error_reporter.dart';
import 'package:bag24/src/core/utils/logger/logger.dart';
import 'package:bag24/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:bag24/src/feature/authentication/data/authentication_repository.dart';
import 'package:bag24/src/feature/biometrics/data/biometrics_repository.dart';
import 'package:bag24/src/feature/home/data/home_repository.dart';
import 'package:bag24/src/feature/initialization/logic/composition_root.dart';
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
import 'package:bag24/src/feature/support/data/mail_repository.dart';
import 'package:bag24/src/feature/system/data/app_state_repository.dart';
import 'package:bag24/src/feature/system/data/device_info_repository.dart';
import 'package:bag24/src/feature/user/data/user_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:push_notification_interface/push_interface.dart';

/// Composed dependencies from the [CompositionRoot].
///
/// This class is used to pass dependencies to the application.
///
/// {@macro composition_process}
base class const DependenciesContainer({
  /// [Logger] instance, used to log messages.
  required final Logger logger,

  /// [ApplicationConfig] instance, contains configuration of the application.
  required final ApplicationConfig config,

  /// [ErrorReporter] instance, used to report errors.
  required final ErrorReporter errorReporter,

  /// [PackageInfo] instance, contains information about the application.
  required final PackageInfo packageInfo,
  required final AppSettingsBloc appSettingsBloc,
  required final AuthenticationBloc authenticationBloc,
  required final AnalyticsInteractor analytics,
  required final IAppStateRepository appStateRepository,
  required final IAuthenticationRepository authenticationRepository,
  required final IBiometricsRepository biometricsRepository,
  required final IDeviceInfoRepository deviceInfoRepository,
  required final IGeolocationRepository geolocationRepository,
  required final IHomeRepository homeRepository,
  required final ILocationRepository locationRepository,
  required final IMailRepository mailRepository,
  required final IMOARepository moaRepository,
  required final IOnboardingRepository onboardingRepository,
  required final IOrderRepository orderRepository,
  required final IPaymentRepository paymentRepository,
  required final IPermissionsRepository permissionsRepository,
  required final IPinRepository pinRepository,
  required final IPushNotificationService pushNotificationProvider,
  required final IStorageRepository storageRepository,
  required final IUserRepository userRepository,
}) {
  /// {@macro dependencies}
  this;
}

/// {@template testing_dependencies_container}
/// A special version of [DependenciesContainer] that is used in tests.
///
/// In order to use [DependenciesContainer] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
/// {@endtemplate}
base class const TestDependenciesContainer() implements DependenciesContainer {
  /// {@macro testing_dependencies_container}
  this;

  @override
  Object noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'The test tries to access ${invocation.memberName} dependency, but '
      'it was not provided. Please provide the dependency in the test. '
      'You can do it by extending this class and providing the dependency.',
    );
  }
}
