part of 'contact_support_bloc.dart';

@Freezed(copyWith: false)
sealed class ContactSupportEvent with _$ContactSupportEvent {
  const factory send(ContactSupportData data) = _ContactSupportSend;
}
