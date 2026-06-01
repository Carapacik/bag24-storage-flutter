import 'package:bag24/src/feature/location/data/location_repository.dart';
import 'package:bag24/src/feature/location/model/location_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/locations/dto/location_dto.dart';
import 'package:rest_client/locations/locations_client.dart';

import '../../../example/geoposition.dart';
import '../../../example/location.dart';
import '../../../mock/mock.dart';

void main() {
  late ILocationRepository locationRepository;
  late LocationsClient mockLocationsClient;
  late MockResponseLocationListDto responseLocationListDto;

  setUp(() {
    mockLocationsClient = MockLocationsClient();
    locationRepository = LocationRepository(locationsClient: mockLocationsClient);
    responseLocationListDto = MockResponseLocationListDto();
  });

  group('LocationRepository', () {
    test('getLocations returns locations without position', () async {
      // Arrange
      when(mockLocationsClient.getLocations(tags: ['STORAGE'])).thenAnswer((_) async => responseLocationListDto);
      when(responseLocationListDto.result).thenReturn(LocationListDto(locations: mockLocationsDto));

      // Act
      final List<Location> result = await locationRepository.getLocations();

      // Assert
      expect(result, mockLocations);
      verify(mockLocationsClient.getLocations(tags: ['STORAGE'])).called(1);
    });

    test('getLocations returns locations with position', () async {
      // Arrange
      when(
        mockLocationsClient.getLocations(
          tags: ['STORAGE'],
          lat: mockGeoPosition.latitude,
          lon: mockGeoPosition.longitude,
        ),
      ).thenAnswer((_) async => responseLocationListDto);
      when(responseLocationListDto.result).thenReturn(LocationListDto(locations: mockLocationsDto));

      // Act
      final List<Location> result = await locationRepository.getLocations(currentPosition: mockGeoPosition);

      // Assert
      expect(result, mockLocations);
      verify(
        mockLocationsClient.getLocations(
          tags: ['STORAGE'],
          lat: mockGeoPosition.latitude,
          lon: mockGeoPosition.longitude,
        ),
      ).called(1);
    });

    test('getLocations throws exception when error occurs', () async {
      // Arrange
      when(mockLocationsClient.getLocations(tags: ['STORAGE'])).thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => locationRepository.getLocations(), throwsException);
    });
  });
}
