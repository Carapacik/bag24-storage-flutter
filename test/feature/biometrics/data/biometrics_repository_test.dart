import 'package:bag24/src/core/components/prefs_storage/biometrics/biometrics_data_source.dart';
import 'package:bag24/src/feature/biometrics/data/biometrics_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'biometrics_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<IBiometricsDataSource>(), MockSpec<LocalAuthentication>()])
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late MockIBiometricsDataSource mockDataSource;
  late MockLocalAuthentication mockLocalAuth;
  late BiometricsRepository biometricsRepository;

  setUp(() {
    mockDataSource = MockIBiometricsDataSource();
    mockLocalAuth = MockLocalAuthentication();
    biometricsRepository = BiometricsRepository(
      biometricsDataSource: mockDataSource,
      localAuthentication: mockLocalAuth,
    );
  });

  group('BiometricsRepository Tests', () {
    // Tests for hasBiometrics
    group('hasBiometrics', () {
      test('returns true if no biometric methods are enabled', () async {
        when(mockDataSource.getFace()).thenAnswer((_) async => true);
        when(mockDataSource.getFingerprint()).thenAnswer((_) async => false);
        when(mockDataSource.getStrong()).thenAnswer((_) async => false);

        final bool result = await biometricsRepository.hasBiometrics();

        expect(result, isTrue);
        verify(mockDataSource.getFace()).called(1);
        verifyNever(mockDataSource.getFingerprint());
        verifyNever(mockDataSource.getStrong());
      });

      test('returns false if no biometric methods are enabled', () async {
        when(mockDataSource.getFace()).thenAnswer((_) async => false);
        when(mockDataSource.getFingerprint()).thenAnswer((_) async => false);
        when(mockDataSource.getStrong()).thenAnswer((_) async => false);

        final bool result = await biometricsRepository.hasBiometrics();

        expect(result, isFalse);
        verify(mockDataSource.getFace()).called(1);
        verify(mockDataSource.getFingerprint()).called(1);
        verify(mockDataSource.getStrong()).called(1);
      });

      test('handles null values gracefully', () async {
        when(mockDataSource.getFace()).thenAnswer((_) async => null);
        when(mockDataSource.getFingerprint()).thenAnswer((_) async => null);
        when(mockDataSource.getStrong()).thenAnswer((_) async => null);

        final bool result = await biometricsRepository.hasBiometrics();

        expect(result, isFalse);
        verify(mockDataSource.getFace()).called(1);
        verify(mockDataSource.getFingerprint()).called(1);
        verify(mockDataSource.getStrong()).called(1);
      });
    });

    // Tests for getFace
    group('getFace', () {
      test('returns true when face biometrics is enabled', () async {
        when(mockDataSource.getFace()).thenAnswer((_) async => true);

        final bool result = await biometricsRepository.getFace();

        expect(result, isTrue);
        verify(mockDataSource.getFace()).called(1);
      });

      test('returns false when face biometrics is disabled', () async {
        when(mockDataSource.getFace()).thenAnswer((_) async => false);

        final bool result = await biometricsRepository.getFace();

        expect(result, isFalse);
        verify(mockDataSource.getFace()).called(1);
      });

      test('returns false when face biometrics is null', () async {
        when(mockDataSource.getFace()).thenAnswer((_) async => null);

        final bool result = await biometricsRepository.getFace();

        expect(result, isFalse);
        verify(mockDataSource.getFace()).called(1);
      });
    });

    // Tests for getFingerprint
    group('getFingerprint', () {
      test('returns true when fingerprint biometrics is enabled', () async {
        when(mockDataSource.getFingerprint()).thenAnswer((_) async => true);

        final bool result = await biometricsRepository.getFingerprint();

        expect(result, isTrue);
        verify(mockDataSource.getFingerprint()).called(1);
      });

      test('returns false when fingerprint biometrics is disabled', () async {
        when(mockDataSource.getFingerprint()).thenAnswer((_) async => false);

        final bool result = await biometricsRepository.getFingerprint();

        expect(result, isFalse);
        verify(mockDataSource.getFingerprint()).called(1);
      });

      test('returns false when fingerprint biometrics is null', () async {
        when(mockDataSource.getFingerprint()).thenAnswer((_) async => null);

        final bool result = await biometricsRepository.getFingerprint();

        expect(result, isFalse);
        verify(mockDataSource.getFingerprint()).called(1);
      });
    });

    // Tests for getStrong
    group('getStrong', () {
      test('returns true when strong biometrics is enabled', () async {
        when(mockDataSource.getStrong()).thenAnswer((_) async => true);

        final bool result = await biometricsRepository.getStrong();

        expect(result, isTrue);
        verify(mockDataSource.getStrong()).called(1);
      });

      test('returns false when strong biometrics is disabled', () async {
        when(mockDataSource.getStrong()).thenAnswer((_) async => false);

        final bool result = await biometricsRepository.getStrong();

        expect(result, isFalse);
        verify(mockDataSource.getStrong()).called(1);
      });

      test('returns false when strong biometrics is null', () async {
        when(mockDataSource.getStrong()).thenAnswer((_) async => null);

        final bool result = await biometricsRepository.getStrong();

        expect(result, isFalse);
        verify(mockDataSource.getStrong()).called(1);
      });
    });

    // Tests for setFace
    group('setFace', () {
      test('calls setFace on data source with correct value', () async {
        const faceValue = true;

        await biometricsRepository.setFace(face: faceValue);

        verify(mockDataSource.setFace(face: faceValue)).called(1);
      });
    });

    // Tests for setFingerprint
    group('setFingerprint', () {
      test('calls setFingerprint on data source with correct value', () async {
        const fingerprintValue = true;

        await biometricsRepository.setFingerprint(fingerprint: fingerprintValue);

        verify(mockDataSource.setFingerprint(fingerprint: fingerprintValue)).called(1);
      });
    });

    // Tests for setStrong
    group('setStrong', () {
      test('calls setStrong on data source with correct value', () async {
        const strongValue = true;

        await biometricsRepository.setStrong(strong: strongValue);

        verify(mockDataSource.setStrong(strong: strongValue)).called(1);
      });
    });
  });
}
