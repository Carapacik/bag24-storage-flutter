import 'package:bag24/src/feature/authentication/data/authentication_repository.dart';
import 'package:bag24/src/feature/authentication/model/app_device_info.dart';
import 'package:bag24/src/feature/authentication/model/input_phone_data.dart';
import 'package:bag24/src/feature/authentication/model/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/account/dto/init_command.dart';
import 'package:rest_client/account/dto/token_dto.dart';
import 'package:rest_client/result_response.dart';
import 'package:retrofit/dio.dart';

import '../../../mock/mock.dart';
import 'clear_storages.mocks.dart';

void main() {
  late MockAccountClient mockAccountClient;
  late MockIAuthenticationDataSource mockAuthenticationDataSource;
  late AuthenticationRepository repository;
  late User seedUser;
  late MockClearStorages mockClearStorages;

  setUp(() {
    mockAccountClient = MockAccountClient();
    mockAuthenticationDataSource = MockIAuthenticationDataSource();
    seedUser = const User.unauthenticated();
    mockClearStorages = MockClearStorages();
    repository = AuthenticationRepository(
      authenticationClient: mockAccountClient,
      authenticationDataSource: mockAuthenticationDataSource,
      seedValue: seedUser,
      clearStorages: mockClearStorages.clearStorages,
    );
  });

  group('AuthenticationRepository', () {
    group('userChanges', () {
      test('emits initial user', () async {
        expect(repository.userChanges(), emitsInOrder([seedUser]));
      });
    });

    group('currentUser', () {
      test('returns the seeded user', () {
        expect(repository.currentUser, equals(seedUser));
      });
    });

    group('initPhone', () {
      test('calls clients initPhone', () async {
        const phone = '1234567890';
        when(mockAccountClient.initPhone(body: anyNamed('body'))).thenAnswer((_) async {});

        await repository.initPhone(phone, SignInType.sms);

        final VerificationResult verification = verify(mockAccountClient.initPhone(body: captureAnyNamed('body')))
          ..called(1);
        final command = verification.captured.single as InitCommand;
        expect(command.phoneNumber, phone);
        expect(command.useTelegram, isFalse);
      });
    });

    group('signIn', () {
      test('updates user and emits new user', () async {
        const phone = '1234567890';
        const otp = '1234';
        const deviceInfo = AppDeviceInfo(
          deviceId: 'device-id',
          type: 'type',
          osVersion: 'os-version',
          appVersion: 'app-version',
          locale: 'locale',
          screenResolution: 'resolution',
          pushToken: 'push-token',
        );
        const tokenDto = TokenDto(access: 'access-token', refresh: 'refresh-token');
        const authenticatedUser = AuthenticatedUser(accessToken: 'access-token', refreshToken: 'refresh-token');

        when(mockAccountClient.verifyPhone(any))
            .thenAnswer((_) async => const ResultResponse<TokenDto>(result: tokenDto, message: '', errorCode: 0));
        when(mockAuthenticationDataSource.setUser(authenticatedUser)).thenAnswer((_) async {});

        final AuthenticatedUser result = await repository.signIn(phone, otp, deviceInfo);

        expect(result, equals(authenticatedUser));
        expect(repository.currentUser, equals(authenticatedUser));
        verify(mockAuthenticationDataSource.setUser(authenticatedUser)).called(1);
      });
    });

    group('signOut', () {
      test('clears storage and sets user to unauthenticated', () async {
        when(mockClearStorages.clearStorages()).thenAnswer((_) async {});

        await repository.signOut();

        expect(repository.currentUser, equals(const User.unauthenticated()));
        verify(mockClearStorages.clearStorages()).called(1);
      });
    });

    group('updateUser', () {
      test('sets user and emits new user', () async {
        const newUser = AuthenticatedUser(accessToken: 'new-access-token', refreshToken: 'new-refresh-token');

        when(mockAuthenticationDataSource.setUser(newUser)).thenAnswer((_) async {});

        await repository.updateUser(newUser);

        expect(repository.currentUser, equals(newUser));
        verify(mockAuthenticationDataSource.setUser(newUser)).called(1);
      });
    });

    group('refreshUser', () {
      test('refreshes user if authenticated', () async {
        const authenticatedUser = AuthenticatedUser(accessToken: 'access-token', refreshToken: 'refresh-token');
        const refreshedUser = AuthenticatedUser(
          accessToken: 'refreshed-access-token',
          refreshToken: 'refreshed-refresh-token',
        );
        const tokenDto = TokenDto(access: 'refreshed-access-token', refresh: 'refreshed-refresh-token');

        when(mockAccountClient.refresh()).thenAnswer(
          (_) async => HttpResponse<ResultResponse<TokenDto>>(
            const ResultResponse(result: tokenDto, message: '', errorCode: 0),
            Response(requestOptions: RequestOptions()),
          ),
        );
        when(mockAuthenticationDataSource.setUser(refreshedUser)).thenAnswer((_) async {});

        await repository.updateUser(authenticatedUser);
        final User result = await repository.refreshUser();

        expect(result, equals(refreshedUser));
        expect(repository.currentUser, equals(refreshedUser));
        verify(mockAuthenticationDataSource.setUser(refreshedUser)).called(1);
      });

      test('calls signOut if user is not authenticated', () async {
        const unauthenticatedUser = User.unauthenticated();

        await repository.updateUser(unauthenticatedUser);
        await repository.refreshUser();

        verify(mockClearStorages.clearStorages()).called(1);
        expect(repository.currentUser, equals(unauthenticatedUser));
      });

      test('calls signOut if refresh fails', () async {
        const authenticatedUser = AuthenticatedUser(accessToken: 'access-token', refreshToken: 'refresh-token');

        when(mockAccountClient.refresh()).thenThrow(Exception('Refresh failed'));

        await repository.updateUser(authenticatedUser);
        final User result = await repository.refreshUser();

        expect(result, equals(const User.unauthenticated()));
        expect(repository.currentUser, equals(const User.unauthenticated()));
        verify(mockClearStorages.clearStorages()).called(1);
      });
    });
  });
}
