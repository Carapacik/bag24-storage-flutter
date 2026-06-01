part of 'banners_bloc.dart';

@Freezed()
sealed class const BannersState._() with _$BannersState {
  const factory idle({required List<BannerData> banners, Storage? nearestStorage}) = _BannersIdle;

  const factory processing({required List<BannerData> banners, Storage? nearestStorage}) = _BannersProcessing;

  const factory success({required List<BannerData> banners, Storage? nearestStorage}) = _BannersSuccess;

  const factory failure({required List<BannerData> banners, required AppException exception, Storage? nearestStorage}) =
      _BannersFailure;
}
