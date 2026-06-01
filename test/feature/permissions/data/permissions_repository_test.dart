import 'package:bag24/src/core/components/prefs_storage/permissions/permissions_data_source.dart';
import 'package:bag24/src/feature/permissions/data/permissions_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../mock/mock.mocks.dart';

void main() {
  late IPermissionsDataSource mockPermissionsDataSource;
  late IPermissionsRepository permissionsRepository;

  setUp(() {
    mockPermissionsDataSource = MockIPermissionsDataSource();
    permissionsRepository = PermissionsRepository(permissionsDataSource: mockPermissionsDataSource);
  });

  group('isLocationEnabled', () {
    test('should return stored location permission status', () async {
      // Arrange
      when(mockPermissionsDataSource.getLocation()).thenAnswer((_) async => true);

      // Act
      final bool? result = await permissionsRepository.isLocationEnabled;

      // Assert
      expect(result, true);
      verify(mockPermissionsDataSource.getLocation()).called(1);
    });
  });

  group('isNotificationEnabled', () {
    test('should return stored notification permission status', () async {
      // Arrange
      when(mockPermissionsDataSource.getNotification()).thenAnswer((_) async => true);

      // Act
      final bool? result = await permissionsRepository.isNotificationEnabled;

      // Assert
      expect(result, true);
      verify(mockPermissionsDataSource.getNotification()).called(1);
    });
  });

  group('setLocation', () {
    test('should set location permission status', () async {
      // Act
      await permissionsRepository.setLocation(location: true);

      // Assert
      verify(mockPermissionsDataSource.setLocation(location: true)).called(1);
    });
  });

  group('setNotification', () {
    test('should set notification permission status', () async {
      // Act
      await permissionsRepository.setNotification(notification: true);

      // Assert
      verify(mockPermissionsDataSource.setNotification(notification: true)).called(1);
    });
  });
}
