part of 'biometrics_bloc.dart';

@Freezed(copyWith: false)
sealed class BiometricsEvent with _$BiometricsEvent {
  const factory setBiometrics(List<BiometricType> availableBiometrics) = _SetBiometrics;
}
