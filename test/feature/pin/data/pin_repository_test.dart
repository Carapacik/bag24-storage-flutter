import 'package:bag24/src/core/components/secure_storage/pin/pin_data_source.dart';
import 'package:bag24/src/feature/pin/data/pin_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mock/mock.dart';

void main() {
  late IPinDataSource mockPinDataSource;
  late IPinRepository pinRepository;

  setUp(() {
    mockPinDataSource = MockIPinDataSource();
    pinRepository = PinRepository(pinDataSource: mockPinDataSource);
  });

  const testPin = '1234';

  group('getPin', () {
    test('should return pin when PinDataSource returns valid pin', () async {
      // Arrange
      when(mockPinDataSource.getPin()).thenAnswer((_) async => testPin);

      // Act
      final String? result = await pinRepository.getPin();

      // Assert
      expect(result, testPin);
      verify(mockPinDataSource.getPin()).called(1);
    });

    test('should return null when PinDataSource returns null', () async {
      // Arrange
      when(mockPinDataSource.getPin()).thenAnswer((_) async => null);

      // Act
      final String? result = await pinRepository.getPin();

      // Assert
      expect(result, null);
      verify(mockPinDataSource.getPin()).called(1);
    });

    test('should rethrow exception if an error occurs', () async {
      // Arrange
      when(mockPinDataSource.getPin()).thenThrow(Exception('Some error'));

      // Act & Assert
      expect(() => pinRepository.getPin(), throwsException);
      verify(mockPinDataSource.getPin()).called(1);
    });
  });

  group('setPin', () {
    test('should successfully set pin', () async {
      // Arrange
      when(mockPinDataSource.setPin(testPin)).thenAnswer((_) async {});

      // Act
      await pinRepository.setPin(testPin);

      // Assert
      verify(mockPinDataSource.setPin(testPin)).called(1);
    });

    test('should rethrow exception if an error occurs during pin setting', () async {
      // Arrange
      when(mockPinDataSource.setPin(testPin)).thenThrow(Exception('Failed to set pin'));

      // Act & Assert
      expect(() => pinRepository.setPin(testPin), throwsException);
      verify(mockPinDataSource.setPin(testPin)).called(1);
    });
  });
}
