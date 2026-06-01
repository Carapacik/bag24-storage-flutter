import 'package:bag24/src/core/components/prefs_storage/user/dao/user_dao.dart';
import 'package:bag24/src/core/components/prefs_storage/user/user_data_source.dart';
import 'package:bag24/src/feature/user/data/user_repository.dart';
import 'package:bag24/src/feature/user/model/user_profile.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/result_response.dart';
import 'package:rest_client/user/dto/user_dto.dart';
import 'package:rest_client/user/user_client.dart';
import 'package:test/test.dart';

import '../../../mock/mock.dart';

void main() {
  late UserClient mockUserClient;
  late IUserDataSource mockUserDataSource;
  late IUserRepository userRepository;

  setUp(() {
    mockUserClient = MockUserClient();
    mockUserDataSource = MockIUserDataSource();

    userRepository = UserRepository(userClient: mockUserClient, userDataSource: mockUserDataSource);
  });

  const userDto = UserDto(
    id: '1',
    phoneNumber: '1234567890',
    firstName: 'John',
    lastName: 'Doe',
    status: UserStatus.init,
  );
  final user = UserProfile.decode(userDto);
  final UserDao userDao = UserProfile.encodeDao(user);

  group('me', () {
    test('should return user when UserClient returns valid response', () async {
      // Arrange
      const mockResponse = ResultResponse<UserDto>(result: userDto, message: '', errorCode: 0);
      when(mockUserClient.me()).thenAnswer((_) async => mockResponse);

      // Act
      final UserProfile? result = await userRepository.me();

      // Assert
      expect(result, user);
      verify(mockUserDataSource.setUserData(userDao)).called(1);
    });

    test('should rethrow exception if an error occurs', () async {
      // Arrange
      when(mockUserClient.me()).thenThrow(Exception('Some error'));

      // Act and Assert
      expect(() => userRepository.me(), throwsException);
      verifyNever(mockUserDataSource.setUserData(userDao)); // Ensure setUserData is not called
    });
  });

  group('update', () {
    test('should call userClient.update and return updated user', () async {
      // Arrange
      const updatedUser = UserDto(
        firstName: 'John',
        lastName: 'Doe',
        id: '',
        phoneNumber: '',
        status: UserStatus.deleted,
      );
      const response = ResultResponse<UserRawDto>(
        result: UserRawDto(user: updatedUser),
        message: '',
        errorCode: 0,
      );

      when(mockUserClient.update(firstName: 'John', lastName: 'Doe', phoneNumber: ''))
          .thenAnswer((_) async => response);

      // Act
      final UserProfile? result = await userRepository.update(firstName: 'John', lastName: 'Doe', phoneNumber: '');

      // Assert
      expect(result, UserProfile.decode(updatedUser));
    });

    test('should rethrow an exception when an error occurs', () async {
      // Arrange
      when(mockUserClient.update(firstName: 'John', lastName: 'Doe', phoneNumber: ''))
          .thenThrow(Exception('Something went wrong'));

      // Act
      Future<UserProfile?> call() => userRepository.update(firstName: 'John', lastName: 'Doe', phoneNumber: '');

      // Assert
      expect(call, throwsException);
    });
  });

  group('register', () {
    test('should call userClient.register and return registered user', () async {
      // Arrange
      const response = ResultResponse<UserDto>(result: userDto, message: '', errorCode: 0);
      when(mockUserClient.register()).thenAnswer((_) => Future.value(response));

      // Act
      await userRepository.register();

      // Assert
      verify(mockUserDataSource.setUserData(userDao)).called(1);
    });

    test('should rethrow an exception when an error occurs', () async {
      // Arrange
      when(mockUserClient.register()).thenThrow(Exception('Something went wrong'));

      // Act and Assert
      expect(() => userRepository.register(), throwsException);
      verifyNever(mockUserDataSource.setUserData(UserProfile.encodeDao(user)));
    });

    group('registerUserAgreements method', () {
      test('should return true when user agreements are successfully registered', () async {
        // Arrange
        when(mockUserClient.registerUserAgreements(userAgreement: true, privacyPolicy: true, companyRules: true))
            .thenAnswer((_) async {});

        // Act
        await userRepository.registerUserAgreements(userAgreement: true, privacyPolicy: true, companyRules: true);

        // Assert
        verify(mockUserClient.registerUserAgreements(userAgreement: true, privacyPolicy: true, companyRules: true))
            .called(1);
      });

      test('should rethrow exception if registration of user agreements fails', () async {
        // Arrange
        when(mockUserClient.registerUserAgreements(userAgreement: true, privacyPolicy: true, companyRules: true))
            .thenThrow(Exception('Registration of user agreements failed'));

        // Act and Assert
        expect(
          () => userRepository.registerUserAgreements(userAgreement: true, privacyPolicy: true, companyRules: true),
          throwsException,
        );
      });
    });

    group('currentUser method', () {
      test('should return current user data if available', () async {
        // Arrange
        when(mockUserDataSource.getUserData()).thenAnswer((_) async => userDao);

        // Act
        final UserProfile? result = await userRepository.getLocalUser();

        // Assert
        expect(result, isNotNull);
      });

      test('should return null if current user data is null', () async {
        // Arrange
        when(mockUserDataSource.getUserData()).thenAnswer((_) async => null);

        // Act
        final UserProfile? result = await userRepository.getLocalUser();

        // Assert
        expect(result, isNull);
      });
    });

    group('removeData method', () {
      test('should remove all data successfully', () async {
        // Act
        await userRepository.removeLocalUser();

        // Assert
        verify(mockUserDataSource.remove()).called(1);
      });
    });

    group('setLocalUser method', () {
      test('should save user data successfully', () async {
        // Act
        await userRepository.setLocalUser(user);

        // Assert
        verify(mockUserDataSource.setUserData(userDao)).called(1);
      });
    });

    group('deleteAccount method', () {
      test('should delete account successfully', () async {
        // Arrange
        when(mockUserClient.deleteAccount()).thenAnswer((_) async {});

        // Act
        await userRepository.deleteAccount();

        // Assert
        verify(mockUserClient.deleteAccount()).called(1);
      });
    });
  });
}
