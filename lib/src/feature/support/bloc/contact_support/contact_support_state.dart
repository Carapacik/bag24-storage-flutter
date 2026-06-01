part of 'contact_support_bloc.dart';

@Freezed()
sealed class const ContactSupportState._() with _$ContactSupportState {
  const factory idle() = _ContactSupportIdle;

  const factory processing() = _ContactSupportProcessing;

  const factory success() = _ContactSupportSuccess;

  const factory failure({required AppException exception}) = _ContactSupportFailure;

  bool get inProgress => maybeMap(processing: (_) => true, orElse: () => false);
}
