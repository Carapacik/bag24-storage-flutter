import 'package:bag24/src/feature/location/model/storage_model.dart';
import 'package:rest_client/locations/dto/short_location_dto.dart';
import 'package:rest_client/storage/dto/storage_dto.dart';

import 'rate.dart';

final List<Storage> mockStorages = mockStoragesDto.map(Storage.decode).toList();

List<StorageDto> mockStoragesDto = [
  StorageDto(
    id: 'storage1',
    status: '',
    name: 'Storage 1',
    lon: 1.234,
    lat: 5.678,
    photoUrl: 'url1',
    location: const ShortLocationDto(id: '1', name: 'Location 1', iata: 'AAA'),
    rates: mockRatesDto,
    specialOfferPaymentAllowed: true,
  ),
  StorageDto(
    id: 'storage2',
    status: '',
    name: 'Storage 2',
    lon: 2.345,
    lat: 6.789,
    photoUrl: 'url2',
    location: const ShortLocationDto(id: '1', name: 'Location 1', iata: 'AAA'),
    rates: mockRatesDto,
    specialOfferPaymentAllowed: true,
  ),
  StorageDto(
    id: 'storage3',
    status: '',
    name: 'Storage 3',
    lon: 3.456,
    lat: 7.890,
    photoUrl: 'url3',
    location: const ShortLocationDto(id: '2', name: 'Location 2', iata: 'BBB'),
    rates: mockRatesDto,
    specialOfferPaymentAllowed: true,
  ),
  StorageDto(
    id: 'storage4',
    status: '',
    name: 'Storage 4',
    lon: 4.567,
    lat: 8.901,
    photoUrl: 'url4',
    location: const ShortLocationDto(id: '2', name: 'Location 2', iata: 'BBB'),
    rates: mockRatesDto,
    specialOfferPaymentAllowed: true,
  ),
  StorageDto(
    id: 'storage5',
    status: '',
    name: 'Storage 5',
    lon: 5.678,
    lat: 9.012,
    photoUrl: 'url5',
    location: const ShortLocationDto(id: '2', name: 'Location 2', iata: 'BBB'),
    rates: mockRatesDto,
    specialOfferPaymentAllowed: true,
  ),
];
