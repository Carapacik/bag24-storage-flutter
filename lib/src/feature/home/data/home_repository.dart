import 'package:bag24/src/feature/home/model/banner_data.dart';
import 'package:rest_client/banners/banners_client.dart';

abstract interface class IHomeRepository() {
  Future<List<BannerData>> get banners;
}

class const HomeRepository({required final BannersClient _bannersClient}) implements IHomeRepository {
  @override
  Future<List<BannerData>> get banners async =>
      await _bannersClient.getBanners().then((dto) => dto.result.banners.map(BannerData.decode).toList());
}
