part of 'biometrics_bloc.dart';

@Freezed()
sealed class const BiometricsState._() with _$BiometricsState {
  const factory idle() = BiometricsIdle;

  const factory success() = BiometricsSuccess;

  const factory failure() = BiometricsFailure;
}
