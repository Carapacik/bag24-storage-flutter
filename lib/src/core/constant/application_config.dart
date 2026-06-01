import 'package:bag24/src/feature/initialization/model/environment.dart';

/// Application configuration
class const ApplicationConfig() {
  /// Creates a new [ApplicationConfig] instance.
  this;

  /// The current environment.
  Environment get environment {
    String env = const String.fromEnvironment('ENVIRONMENT').trim();

    if (env.isNotEmpty) {
      return Environment.from(env);
    }

    env = const String.fromEnvironment('FLUTTER_APP_FLAVOR').trim();

    return Environment.from(env);
  }

  /// The Sentry DSN.
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN').trim();

  /// Whether Sentry is enabled.
  bool get enableSentry => sentryDsn.isNotEmpty;

  String get apiUrl => const String.fromEnvironment('API_URL');

  String get apiUrlDomain => const String.fromEnvironment('API_URL_DOMAIN');

  String get mailSupportEmail => const String.fromEnvironment('MAIL_SUPPORT_EMAIL');

  String get mailClientEmail => const String.fromEnvironment('MAIL_CLIENT_EMAIL');

  String get mailClientPassword => const String.fromEnvironment('MAIL_CLIENT_PASSWORD');

  String get appMetricaKey => const String.fromEnvironment('APP_METRICA_KEY');
}

/// {@template testing_dependencies_container}
/// A special version of [ApplicationConfig] that is used in tests.
///
/// In order to use [ApplicationConfig] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
/// {@endtemplate}
base class const TestConfig() implements ApplicationConfig {
  /// {@macro testing_dependencies_container}
  this;

  @override
  Object noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'The test tries to access ${invocation.memberName} (${invocation.runtimeType}) config option, but '
      'it was not provided. Please provide the option in the test. '
      'You can do it by extending this class and providing the option.',
    );
  }
}
