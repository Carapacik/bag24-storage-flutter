part of 'edit_profile_bloc.dart';

@Freezed(copyWith: false)
sealed class EditProfileEvent with _$EditProfileEvent {
  const factory start() = _EditProfileStarted;

  const factory save(String firstName, String lastName) = _EditProfileSave;
}
