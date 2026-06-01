part of 'profile_bloc.dart';

@Freezed()
sealed class const ProfileState._() with _$ProfileState {
  const factory idle(UserProfile? data) = _ProfileIdle;

  const factory processing(UserProfile? data) = _ProfileProcessing;

  const factory success(UserProfile? data) = _ProfileSuccess;

  const factory deletedSuccess(UserProfile? data) = _ProfileDeletedSuccess;

  const factory failure(UserProfile? data, {required AppException exception}) = _ProfileFailure;

  const factory deletedFailure(UserProfile? data, {required AppException exception}) = _ProfileDeletedFailure;
}
