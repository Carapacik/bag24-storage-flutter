part of 'splash_bloc.dart';

@Freezed()
sealed class const SplashState._() with _$SplashState {
  const factory processing() = _SplashProcessing;

  const factory success(Routes route) = _SplashSuccess;

  const factory failure(Routes route, {String? latestVersion}) = _SplashFailure;
}
