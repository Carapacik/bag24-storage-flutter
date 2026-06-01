part of 'banners_bloc.dart';

@Freezed(copyWith: false)
sealed class BannersEvent with _$BannersEvent {
  const factory start() = _BannersStarted;

  const factory updateBookBanner(Position position) = _BannersUpdateBookBanner;
}
