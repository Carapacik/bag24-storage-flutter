import 'package:bag24/src/feature/biometrics/bloc/biometrics_bloc.dart';
import 'package:bag24/src/feature/biometrics/data/biometrics_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mocktail/mocktail.dart';

class MockBiometricsRepository() extends Mock implements IBiometricsRepository;

void main() {
  group('BiometricsBloc', () {
    late IBiometricsRepository biometricsRepository;
    late BiometricsBloc bloc;

    setUp(() {
      biometricsRepository = MockBiometricsRepository();
      bloc = BiometricsBloc(biometricsRepository: biometricsRepository);
    });

    tearDown(() async {
      await bloc.close();
    });

    test('initial state should be idle', () {
      expect(bloc.state, const BiometricsState.idle());
    });

    blocTest<BiometricsBloc, BiometricsState>(
      'should set strong biometrics',
      setUp: () async {
        when(() => biometricsRepository.setStrong(strong: true)).thenAnswer((_) async {});
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const BiometricsEvent.setBiometrics([BiometricType.strong])),
      expect: () => const [BiometricsState.success(), BiometricsState.idle()],
      verify: (_) async {
        verify(() => biometricsRepository.setStrong(strong: true)).called(1);
        verifyNever(() => biometricsRepository.setFace(face: true));
        verifyNever(() => biometricsRepository.setFingerprint(fingerprint: true));
      },
    );

    blocTest<BiometricsBloc, BiometricsState>(
      'should set face biometrics',
      setUp: () async {
        when(() => biometricsRepository.setFace(face: true)).thenAnswer((_) async {});
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const BiometricsEvent.setBiometrics([BiometricType.face])),
      expect: () => const [BiometricsState.success(), BiometricsState.idle()],
      verify: (_) async {
        verify(() => biometricsRepository.setFace(face: true)).called(1);
        verifyNever(() => biometricsRepository.setStrong(strong: true));
        verifyNever(() => biometricsRepository.setFingerprint(fingerprint: true));
      },
    );

    blocTest<BiometricsBloc, BiometricsState>(
      'should set fingerprint biometrics',
      setUp: () async {
        when(() => biometricsRepository.setFingerprint(fingerprint: true)).thenAnswer((_) async {});
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const BiometricsEvent.setBiometrics([BiometricType.fingerprint])),
      expect: () => const [BiometricsState.success(), BiometricsState.idle()],
      verify: (_) async {
        verify(() => biometricsRepository.setFingerprint(fingerprint: true)).called(1);
        verifyNever(() => biometricsRepository.setStrong(strong: true));
        verifyNever(() => biometricsRepository.setFace(face: true));
      },
    );

    blocTest<BiometricsBloc, BiometricsState>(
      'should emit failure when error occurs',
      setUp: () async {
        when(() => biometricsRepository.setStrong(strong: true)).thenThrow(Exception('Error'));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const BiometricsEvent.setBiometrics([BiometricType.strong])),
      expect: () => const [BiometricsState.failure(), BiometricsState.idle()],
    );

    blocTest<BiometricsBloc, BiometricsState>(
      'should not set biometrics when list is empty',
      build: () => bloc,
      act: (bloc) => bloc.add(const BiometricsEvent.setBiometrics([])),
      expect: () => const [BiometricsState.success(), BiometricsState.idle()],
      verify: (_) async {
        verifyNever(() => biometricsRepository.setStrong(strong: true));
        verifyNever(() => biometricsRepository.setFace(face: true));
        verifyNever(() => biometricsRepository.setFingerprint(fingerprint: true));
      },
    );
  });
}
