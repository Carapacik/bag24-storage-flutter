import 'dart:async';

import 'package:bag24/src/core/exception/exception_handler.dart';
import 'package:bag24/src/feature/user/data/user_repository.dart';
import 'package:bag24/src/feature/user/model/user_profile.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_bloc.freezed.dart';
part 'profile_event.dart';
part 'profile_state.dart';

final class ProfileBloc({required final IUserRepository _userRepository}) extends Bloc<ProfileEvent, ProfileState> {
  this : super(const ProfileState.idle(null)) {
    on<ProfileEvent>(
      (event, emit) async => await switch (event) {
        final _ProfileStarted e => _start(e, emit),
        final _ProfileDeleteAccount e => _deleteAccount(e, emit),
      },
    );
    add(const ProfileEvent.start());
  }

  Future<void> _start(_ProfileStarted event, Emitter<ProfileState> emitter) async {
    emitter(ProfileState.processing(state.data));
    await ExceptionHandler.handle(
      () async {
        final UserProfile? data = await _userRepository.getLocalUser();
        emitter(ProfileState.success(data));
      },
      onError: (exception, stackTrace) => emitter(ProfileState.failure(state.data, exception: exception)),
      onDone: () => emitter(ProfileState.idle(state.data)),
    );
  }

  Future<void> _deleteAccount(_ProfileDeleteAccount event, Emitter<ProfileState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        await _userRepository.deleteAccount();
        emitter(ProfileState.deletedSuccess(state.data));
      },
      onError: (exception, stackTrace) => emitter(ProfileState.deletedFailure(state.data, exception: exception)),
      onDone: () => emitter(ProfileState.idle(state.data)),
    );
  }
}
