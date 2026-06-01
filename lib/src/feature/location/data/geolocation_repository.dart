import 'dart:async';

import 'package:geolocator/geolocator.dart';

abstract class IGeolocationRepository() {
  Future<void> requestPermission();

  Future<Position> getCurrentPosition();
}

class const GeolocationRepository({required final GeolocatorPlatform _geolocator}) implements IGeolocationRepository {
  @override
  Future<void> requestPermission() async {
    final bool isLocationServiceEnabled = await _geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      return;
    }
    final LocationPermission permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await _geolocator.requestPermission();
    }
  }

  @override
  Future<Position> getCurrentPosition() => _geolocator.getCurrentPosition();
}
