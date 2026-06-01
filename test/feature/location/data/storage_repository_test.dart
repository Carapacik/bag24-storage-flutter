import 'package:bag24/src/feature/location/data/storage_repository.dart';
import 'package:bag24/src/feature/location/model/storage_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/storage/dto/storage_dto.dart';
import 'package:rest_client/storage/storage_client.dart';

import '../../../example/geoposition.dart';
import '../../../example/storage.dart';
import '../../../mock/mock.dart';

void main() {
  late IStorageRepository storageRepository;
  late StorageClient storageClient;
  late MockResponseStorageListDto responseStorageListDto;
  late MockResponseStorageDto responseStorageDto;

  setUp(() {
    storageClient = MockStorageClient();
    storageRepository = StorageRepository(storageClient: storageClient);
    responseStorageListDto = MockResponseStorageListDto();
    responseStorageDto = MockResponseStorageDto();
  });

  group('StorageRepository', () {
    group('getStorages', () {
      test('returns a list of storages with default parameters', () async {
        // Arrange
        when(storageClient.getStorages(offset: 0)).thenAnswer((_) async => responseStorageListDto);
        when(responseStorageListDto.result).thenReturn(StorageListDto(storages: mockStoragesDto));

        // Act
        final List<Storage> result = await storageRepository.getStorages();

        // Assert
        expect(result, mockStorages);
        verify(storageClient.getStorages(offset: 0)).called(1);
      });

      test('returns a list of storages with position', () async {
        // Arrange
        when(storageClient.getStorages(offset: 0, lat: mockGeoPosition.latitude, lon: mockGeoPosition.longitude))
            .thenAnswer((_) async => responseStorageListDto);
        when(responseStorageListDto.result).thenReturn(StorageListDto(storages: mockStoragesDto));

        // Act
        final List<Storage> result = await storageRepository.getStorages(position: mockGeoPosition);

        // Assert
        expect(result, mockStorages);
        verify(storageClient.getStorages(offset: 0, lat: mockGeoPosition.latitude, lon: mockGeoPosition.longitude))
            .called(1);
      });

      test('returns a list of storages with search query', () async {
        // Arrange
        const searchQuery = 'test';
        when(storageClient.getStorages(offset: 0, name: searchQuery)).thenAnswer((_) async => responseStorageListDto);
        when(responseStorageListDto.result).thenReturn(StorageListDto(storages: mockStoragesDto));

        // Act
        final List<Storage> result = await storageRepository.getStorages(searchQuery: searchQuery);

        // Assert
        expect(result, mockStorages);
        verify(storageClient.getStorages(offset: 0, name: searchQuery)).called(1);
      });

      test('returns a list of storages with custom offset and limit', () async {
        // Arrange
        const customOffset = 20;
        const customLimit = 30;
        when(storageClient.getStorages(offset: customOffset, limit: customLimit))
            .thenAnswer((_) async => responseStorageListDto);
        when(responseStorageListDto.result).thenReturn(StorageListDto(storages: mockStoragesDto));

        // Act
        final List<Storage> result = await storageRepository.getStorages(offset: customOffset, limit: customLimit);

        // Assert
        expect(result, mockStorages);
        verify(storageClient.getStorages(offset: customOffset, limit: customLimit)).called(1);
      });

      test('returns a list of storages with all parameters combined', () async {
        // Arrange
        const customOffset = 5;
        const customLimit = 15;
        const searchQuery = 'test';
        when(
          storageClient.getStorages(
            offset: customOffset,
            limit: customLimit,
            lat: mockGeoPosition.latitude,
            lon: mockGeoPosition.longitude,
            name: searchQuery,
          ),
        ).thenAnswer((_) async => responseStorageListDto);
        when(responseStorageListDto.result).thenReturn(StorageListDto(storages: mockStoragesDto));

        // Act
        final List<Storage> result = await storageRepository.getStorages(
          offset: customOffset,
          limit: customLimit,
          position: mockGeoPosition,
          searchQuery: searchQuery,
        );

        // Assert
        expect(result, mockStorages);
        verify(
          storageClient.getStorages(
            offset: customOffset,
            limit: customLimit,
            lat: mockGeoPosition.latitude,
            lon: mockGeoPosition.longitude,
            name: searchQuery,
          ),
        ).called(1);
      });

      test('throws exception when error occurs', () async {
        // Arrange
        when(storageClient.getStorages(offset: 0)).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => storageRepository.getStorages(), throwsException);
      });
    });

    group('getStorageById', () {
      test('returns storage by id', () async {
        // Arrange
        const storageId = 'test-id';
        when(storageClient.getStorage(storageId: storageId)).thenAnswer((_) async => responseStorageDto);
        when(responseStorageDto.result).thenReturn(mockStoragesDto.first);

        // Act
        final Storage result = await storageRepository.getStorageById(storageId);

        // Assert
        expect(result, mockStorages.first);
        verify(storageClient.getStorage(storageId: storageId)).called(1);
      });

      test('throws exception when error occurs', () async {
        // Arrange
        const storageId = 'test-id';
        when(storageClient.getStorage(storageId: storageId)).thenThrow(Exception('Network error'));

        // Act & Assert
        expect(() => storageRepository.getStorageById(storageId), throwsException);
      });
    });
  });
}
