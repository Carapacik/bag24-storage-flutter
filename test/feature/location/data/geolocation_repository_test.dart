import 'package:bag24/src/feature/location/data/geolocation_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../example/geoposition.dart';
import '../../../mock/mock.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  late GeolocationRepository geolocationRepository;
  late GeolocatorPlatform mockGeolocator;

  setUp(() {
    mockGeolocator = MockGeolocatorPlatform();
    geolocationRepository = GeolocationRepository(geolocator: mockGeolocator);
  });

  group('GeoLocationRepository', () {
    test('getCurrentPosition should return a valid Position', () async {
      // Arrange
      when(mockGeolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);
      when(mockGeolocator.checkPermission()).thenAnswer((_) async => LocationPermission.whileInUse);
      when(mockGeolocator.getCurrentPosition()).thenAnswer((_) async => mockGeoPosition);
      // Act
      final Position position = await geolocationRepository.getCurrentPosition();

      // Assert
      expect(position, equals(mockGeoPosition));
    });

    test('requestLocationPermissionIfPossible should request permission if service is enabled', () async {
      // Arrange
      when(mockGeolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);
      when(mockGeolocator.checkPermission()).thenAnswer((_) async => LocationPermission.denied);
      when(mockGeolocator.requestPermission()).thenAnswer((_) async => LocationPermission.denied);

      // Act
      await geolocationRepository.requestPermission();

      // Assert
      verify(mockGeolocator.isLocationServiceEnabled());
      verify(mockGeolocator.checkPermission());
      verify(mockGeolocator.requestPermission());
    });

    test('requestLocationPermissionIfPossible should not request permission if service is disabled', () async {
      // Arrange
      when(mockGeolocator.isLocationServiceEnabled()).thenAnswer((_) async => false);

      // Act
      await geolocationRepository.requestPermission();

      // Assert
      verify(mockGeolocator.isLocationServiceEnabled());
      verifyNever(mockGeolocator.checkPermission());
      verifyNever(mockGeolocator.requestPermission());
    });

    test('requestLocationPermissionIfPossible should not request permission if already granted', () async {
      // Arrange
      when(mockGeolocator.isLocationServiceEnabled()).thenAnswer((_) async => true);
      when(mockGeolocator.checkPermission()).thenAnswer((_) async => LocationPermission.whileInUse);

      // Act
      await geolocationRepository.requestPermission();

      // Assert
      verify(mockGeolocator.isLocationServiceEnabled());
      verify(mockGeolocator.checkPermission());
      verifyNever(mockGeolocator.requestPermission());
    });
  });
}
