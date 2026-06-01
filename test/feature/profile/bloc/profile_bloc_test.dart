import 'package:bag24/src/feature/profile/bloc/profile/profile_bloc.dart';
import 'package:bag24/src/feature/user/model/user_profile.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/user/dto/user_dto.dart';

import '../../../mock/mock.dart';

void main() {
  late MockIUserRepository mockUserRepository;
  late ProfileBloc profileBloc;

  setUp(() {
    mockUserRepository = MockIUserRepository();
    profileBloc = ProfileBloc(userRepository: mockUserRepository);
  });

  group('ProfileBloc', () {
    const user = UserProfile(id: '1', phoneNumber: '1234567890', status: UserStatus.active);

    test('initial state is ProfileState.idle', () {
      expect(profileBloc.state, const ProfileState.idle(null));
    });

    blocTest<ProfileBloc, ProfileState>(
      'emits [processing, success, idle] when start event is successful',
      setUp: () async {
        when(mockUserRepository.getLocalUser()).thenAnswer((_) async => user);
      },
      build: () => profileBloc,
      act: (bloc) => bloc.add(const ProfileEvent.start()),
      expect: () => [
        const ProfileState.processing(null),
        const ProfileState.success(user),
        const ProfileState.idle(user),
      ],
    );

    // TODO(akozlov): разобраться
    // blocTest<ProfileBloc, ProfileState>(
    //   'emits [processing, failure, idle] when start event fails',
    //   setUp: () {
    //     when(mockUserRepository.currentUser).thenThrow(Exception('Failed to load user'));
    //   },
    //   build: () => profileBloc,
    //   act: (bloc) => bloc.add(const ProfileEvent.start()),
    //   expect: () => [
    //     const ProfileState.processing(null),
    //     const ProfileState.failure(null, exception: AppException.unknown('Exception: Failed to load user')),
    //     // isA<ProfileState>().having((state) => state.isFailure, 'isFailure', true),
    //     const ProfileState.idle(null),
    //   ],
    // );

    blocTest<ProfileBloc, ProfileState>(
      'emits [deletedSuccess, idle] when deleteAccount is successful',
      setUp: () async {
        when(mockUserRepository.deleteAccount()).thenAnswer((_) async {});
      },
      build: () => profileBloc,
      act: (bloc) => bloc.add(const ProfileEvent.deleteAccount()),
      expect: () => [const ProfileState.deletedSuccess(null), const ProfileState.idle(null)],
      verify: (_) async {
        verify(mockUserRepository.deleteAccount()).called(1);
      },
    );

    // TODO(akozlov): разобраться
    // blocTest<ProfileBloc, ProfileState>(
    //   'emits [deletedFailure, idle] when deleteAccount fails',
    //   setUp: () async {
    //     when(mockUserRepository.deleteAccount()).thenThrow(Exception('Failed to delete account'));
    //   },
    //   build: () => profileBloc,
    //   act: (bloc) => bloc.add(const ProfileEvent.deleteAccount()),
    //   expect: () => [
    //     const ProfileState.failure(null, exception: AppException.unknown('Exception: Failed to delete account')),
    //     // isA<ProfileState>().having((state) => state.isDeletedFailure, 'isDeletedFailure', true),
    //     const ProfileState.idle(null),
    //   ],
    // );
  });
}
