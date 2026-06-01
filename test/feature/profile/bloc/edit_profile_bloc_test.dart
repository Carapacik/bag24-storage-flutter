import 'package:bag24/src/feature/profile/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:bag24/src/feature/user/model/user_profile.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rest_client/user/dto/user_dto.dart';

import '../../../mock/mock.dart';

void main() {
  late MockIUserRepository mockUserRepository;
  late EditProfileBloc bloc;

  setUp(() {
    mockUserRepository = MockIUserRepository();
    bloc = EditProfileBloc(userRepository: mockUserRepository);
  });

  group('EditProfileBloc', () {
    const user = UserProfile(
      id: '1',
      phoneNumber: '1234567890',
      status: UserStatus.active,
      firstName: 'OldFirstName',
      lastName: 'OldLastName',
    );

    test('initial state is EditProfileState.idle', () {
      expect(bloc.state, const EditProfileState.idle(firstName: '', lastName: ''));
    });

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [processing, idle] when initial event is successful',
      setUp: () async {
        when(mockUserRepository.getLocalUser()).thenAnswer((_) async => user);
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const EditProfileEvent.start()),
      expect: () => [
        const EditProfileState.processing(firstName: '', lastName: ''),
        const EditProfileState.idle(firstName: 'OldFirstName', lastName: 'OldLastName'),
      ],
    );

    // TODO(akozlov): разобраться
    // blocTest<EditProfileBloc, EditProfileState>(
    //   'emits [processing, failure, idle] when initial event fails',
    //   setUp: () {
    //     when(mockUserRepository.currentUser).thenThrow(Exception('Failed to load user'));
    //   },
    //   build: () => bloc,
    //   act: (bloc) => bloc.add(const EditProfileEvent.initial()),
    //   expect: () => [
    //     const EditProfileState.processing(firstName: '', lastName: ''),
    //     isA<EditProfileState>().having((state) => state.isFailure, 'isFailure', true),
    //     const EditProfileState.idle(firstName: '', lastName: ''),
    //   ],
    // );

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [processing, success, idle] when save is successful',
      setUp: () async {
        when(mockUserRepository.getLocalUser()).thenAnswer((_) async => user);
        when(mockUserRepository.update(firstName: 'NewFirstName', lastName: 'NewLastName', phoneNumber: '1234567890'))
            .thenAnswer((_) async => user.copyWith(firstName: 'NewFirstName', lastName: 'NewLastName'));
      },
      build: () => bloc,
      act: (bloc) => bloc.add(const EditProfileEvent.save('NewFirstName', 'NewLastName')),
      expect: () => [
        const EditProfileState.processing(firstName: '', lastName: ''),
        const EditProfileState.success(firstName: '', lastName: ''),
        const EditProfileState.idle(firstName: '', lastName: ''),
      ],
      verify: (_) async {
        verify(mockUserRepository.setLocalUser(any)).called(1);
      },
    );

    // TODO(akozlov): разобраться
    // blocTest<EditProfileBloc, EditProfileState>(
    //   'emits [processing, failure, idle] when save fails',
    //   setUp: () async {
    //     when(mockUserRepository.currentUser).thenAnswer((_) async => user);
    //     when(
    //       mockUserRepository.update(
    //         firstName: any,
    //         lastName: any,
    //         phoneNumber: any,
    //       ),
    //     ).thenThrow(Exception('Failed to update'));
    //   },
    //   build: () => bloc,
    //   act: (bloc) => bloc.add(
    //     const EditProfileEvent.save('NewFirstName', 'NewLastName'),
    //   ),
    //   expect: () => [
    //     const EditProfileState.processing(firstName: '', lastName: ''),
    //     isA<EditProfileState>().having((state) => state.isFailure, 'isFailure', true),
    //     const EditProfileState.idle(firstName: '', lastName: ''),
    //   ],
    // );

    // blocTest<EditProfileBloc, EditProfileState>(
    //   'emits [processing, failure, idle] when update returns null',
    //   setUp: () async {
    //     when(mockUserRepository.currentUser).thenAnswer((_) async => user);
    //     when(
    //       mockUserRepository.update(
    //         firstName: any,
    //         lastName: any,
    //         phoneNumber: any,
    //       ),
    //     ).thenAnswer((_) async => null);
    //   },
    //   build: () => bloc,
    //   act: (bloc) => bloc.add(
    //     const EditProfileEvent.save('NewFirstName', 'NewLastName'),
    //   ),
    //   expect: () => [
    //     const EditProfileState.processing(firstName: '', lastName: ''),
    //     isA<EditProfileState>().having((state) => state.isFailure, 'isFailure', true),
    //     const EditProfileState.idle(firstName: '', lastName: ''),
    //   ],
    // );
  });
}
