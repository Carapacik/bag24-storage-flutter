import 'package:bag24/src/core/components/prefs_storage/moa/moa_data_source.dart';
import 'package:rest_client/user/user_client.dart';

abstract interface class IMOARepository() {
  Future<void> registerMoa();

  Future<int> get miles;

  Future<int?> get cachedMiles;
}

final class const MOARepository({required final UserClient _userClient, required final IMOADataSource _moaDataSource})
    implements IMOARepository {
  @override
  Future<void> registerMoa() => _userClient.registerMoa();

  @override
  Future<int> get miles async {
    final int miles = await _userClient.getMiles().then((dto) => dto.result.miles);
    await _moaDataSource.setMiles(miles);
    return miles;
  }

  @override
  Future<int?> get cachedMiles => _moaDataSource.getMiles();
}
