part of 'edit_profile_bloc.dart';

@Freezed()
sealed class const EditProfileState._() with _$EditProfileState {
  const factory idle({required String firstName, required String lastName}) = _EditProfileStateIdle;

  const factory processing({required String firstName, required String lastName}) = _EditProfileStateProcessing;

  const factory success({required String firstName, required String lastName}) = _EditProfileStateSuccess;

  const factory failure({required String firstName, required String lastName, required AppException exception}) =
      _EditProfileStateFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}
