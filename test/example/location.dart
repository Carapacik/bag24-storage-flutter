import 'package:bag24/src/feature/location/model/location_model.dart';
import 'package:rest_client/locations/dto/location_dto.dart';

/// Location Example
final List<LocationDto> mockLocationsDto = [_moscow, _stPetersburg, _ekaterinburg, _kazan];
final List<Location> mockLocations = mockLocationsDto.map(Location.decode).toList();

const LocationDto _moscow = LocationDto(
  id: '1',
  type: 'City',
  name: 'Moscow',
  shortName: 'MOW',
  status: LocationStatusTypeDto.active,
  photoUrl: 'https://example.com/moscow.jpg',
  city: 'Moscow',
  country: 'Russia',
  coordinates: CoordinatesDataDto(type: 'Point', coordinates: [55.7558, 37.6176]),
  area: AreaDataDto(
    coordinates: [
      [
        [30.227319, 60.052887],
        [30.264319, 60.021420],
        [30.230637, 60.012031],
        [30.181262, 60.037061],
        [30.227319, 60.052887],
      ],
    ],
    type: 'AREA',
  ),
  distance: 0,
);

const LocationDto _stPetersburg = LocationDto(
  id: '2',
  type: 'City',
  name: 'St. Petersburg',
  shortName: 'LED',
  status: LocationStatusTypeDto.active,
  photoUrl: 'https://example.com/stpetersburg.jpg',
  city: 'St. Petersburg',
  country: 'Russia',
  coordinates: CoordinatesDataDto(type: 'Point', coordinates: [59.9343, 30.3351]),
  area: AreaDataDto(
    coordinates: [
      [
        [30.264319, 59.991420],
        [30.330637, 59.989031],
        [30.381262, 59.937061],
        [30.427319, 59.952887],
        [30.264319, 59.991420],
      ],
    ],
    type: 'AREA',
  ),
  distance: 0,
);

const LocationDto _ekaterinburg = LocationDto(
  id: '3',
  type: 'City',
  name: 'Ekaterinburg',
  shortName: 'SVX',
  status: LocationStatusTypeDto.active,
  photoUrl: 'https://example.com/ekaterinburg.jpg',
  city: 'Ekaterinburg',
  country: 'Russia',
  coordinates: CoordinatesDataDto(type: 'Point', coordinates: [56.8389, 60.6057]),
  area: AreaDataDto(
    coordinates: [
      [
        [60.5367, 56.8087],
        [60.5402, 56.8421],
        [60.6311, 56.8475],
        [60.6271, 56.8141],
        [60.5367, 56.8087],
      ],
    ],
    type: 'AREA',
  ),
  distance: 0,
);

const LocationDto _kazan = LocationDto(
  id: '4',
  type: 'City',
  name: 'Kazan',
  shortName: 'KZN',
  status: LocationStatusTypeDto.active,
  photoUrl: 'https://example.com/kazan.jpg',
  city: 'Kazan',
  country: 'Russia',
  coordinates: CoordinatesDataDto(type: 'Point', coordinates: [55.7558, 49.1523]),
  area: AreaDataDto(
    coordinates: [
      [
        [49.0734, 55.7512],
        [49.0739, 55.7839],
        [49.1224, 55.7840],
        [49.1219, 55.7512],
        [49.0734, 55.7512],
      ],
    ],
    type: 'AREA',
  ),
  distance: 0,
);
