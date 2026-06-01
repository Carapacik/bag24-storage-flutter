import 'package:rest_client/banners/dto/banner_dto.dart';

class const BannerData({
  required final String id,
  required final String photoUrl,
  required final int position,
  required final String url,
  required final String inAppPath,
}) {
  factory decode(BannerDto dto) =>
      BannerData(id: dto.id, photoUrl: dto.photoUrl, position: dto.position, url: dto.url, inAppPath: dto.inAppPath);
}
