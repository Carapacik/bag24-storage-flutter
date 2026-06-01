import 'package:bag24/src/feature/biometrics/data/biometrics_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:local_auth/local_auth.dart';

part 'biometrics_bloc.freezed.dart';
part 'biometrics_event.dart';
part 'biometrics_state.dart';

final class BiometricsBloc({required final IBiometricsRepository _biometricsRepository})
    extends Bloc<BiometricsEvent, BiometricsState> {
  this : super(const BiometricsState.idle()) {
    on<BiometricsEvent>(
      (event, emit) async => await switch (event) {
        final _SetBiometrics e => _setBiometrics(e, emit),
      },
    );
  }

  Future<void> _setBiometrics(_SetBiometrics event, Emitter<BiometricsState> emitter) async {
    try {
      if (event.availableBiometrics.contains(BiometricType.strong)) {
        await _biometricsRepository.setStrong(strong: true);
      } else if (event.availableBiometrics.contains(BiometricType.face)) {
        await _biometricsRepository.setFace(face: true);
      } else if (event.availableBiometrics.contains(BiometricType.fingerprint)) {
        await _biometricsRepository.setFingerprint(fingerprint: true);
      }
      emitter(const BiometricsState.success());
    } on Object {
      emitter(const BiometricsState.failure());
    } finally {
      emitter(const BiometricsState.idle());
    }
  }
}
