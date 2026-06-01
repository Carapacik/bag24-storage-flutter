import 'package:bag24/src/core/components/secure_storage/pin/pin_data_source.dart';

abstract interface class IPinRepository() {
  Future<String?> getPin();

  Future<void> setPin(String pin);
}

class const PinRepository({required final IPinDataSource _pinDataSource}) implements IPinRepository {
  @override
  Future<String?> getPin() => _pinDataSource.getPin();

  @override
  Future<void> setPin(String pin) => _pinDataSource.setPin(pin);
}
