import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/user/data/user_repository.dart';
import 'package:bag24/src/feature/user/model/user_profile.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_profile_bloc.freezed.dart';
part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

final class EditProfileBloc({required final IUserRepository _userRepository})
    extends Bloc<EditProfileEvent, EditProfileState> {
  this : super(const EditProfileState.idle(firstName: '', lastName: '')) {
    on<EditProfileEvent>(
      (event, emit) async => await switch (event) {
        final _EditProfileStarted e => _start(e, emit),
        final _EditProfileSave e => _save(e, emit),
      },
    );
  }

  Future<void> _start(_EditProfileStarted event, Emitter<EditProfileState> emitter) async {
    emitter(EditProfileState.processing(firstName: state.firstName, lastName: state.lastName));
    await ExceptionHandler.handle(
      () async {
        final UserProfile? user = await _userRepository.getLocalUser();
        if (user != null) {
          emitter(EditProfileState.idle(firstName: user.firstName ?? '', lastName: user.lastName ?? ''));
        }
      },
      onError: (exception, stackTrace) =>
          emitter(EditProfileState.failure(firstName: state.firstName, lastName: state.lastName, exception: exception)),
      onDone: () => emitter(EditProfileState.idle(firstName: state.firstName, lastName: state.lastName)),
    );
  }

  Future<void> _save(_EditProfileSave event, Emitter<EditProfileState> emitter) async {
    emitter(EditProfileState.processing(firstName: state.firstName, lastName: state.lastName));
    await ExceptionHandler.handle(
      () async {
        final UserProfile? localUser = await _userRepository.getLocalUser();
        if (localUser == null) {
          throw Exception('User must be not null');
        }
        final UserProfile? newUser = await _userRepository.update(
          firstName: event.firstName,
          lastName: event.lastName,
          phoneNumber: localUser.phoneNumber,
        );

        if (newUser != null) {
          await _userRepository.setLocalUser(newUser);
          emitter(EditProfileState.success(firstName: state.firstName, lastName: state.lastName));
        }
      },
      onError: (exception, stackTrace) =>
          emitter(EditProfileState.failure(firstName: state.firstName, lastName: state.lastName, exception: exception)),
      onDone: () => emitter(EditProfileState.idle(firstName: state.firstName, lastName: state.lastName)),
    );
  }
}
