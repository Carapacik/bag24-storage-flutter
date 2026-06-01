import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class IPinDataSource() {
  Future<String?> getPin();

  Future<void> setPin(String pin);

  Future<void> remove();
}

class const PinDataSource({required final FlutterSecureStorage _secureStorage}) implements IPinDataSource {
  static const _pinKey = 'authentication.pin';

  @override
  Future<String?> getPin() async {
    try {
      final String? pin = await _secureStorage.read(key: _pinKey);
      return pin;
    } on Object {
      return null;
    }
  }

  @override
  Future<void> setPin(String pin) async {
    try {
      await _secureStorage.write(key: _pinKey, value: pin);
    } on Object {
      //
    }
  }

  @override
  Future<void> remove() async {
    try {
      await _secureStorage.delete(key: _pinKey);
    } on Object {
      //
    }
  }
}
