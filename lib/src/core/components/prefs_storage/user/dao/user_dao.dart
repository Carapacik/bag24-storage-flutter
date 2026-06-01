import 'package:meta/meta.dart';

@immutable
class const UserDao({
  required final String id,
  required final String phoneNumber,
  required final String status,
  required final String? firstName,
  required final String? lastName,
  required final String sex,
  required final DateTime? birthDate,
}) {
  factory fromJson(Map<String, Object?> json) => UserDao(
    id: json['id']! as String,
    phoneNumber: json['phoneNumber']! as String,
    status: json['status']! as String,
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    sex: json['sex']! as String,
    birthDate: json['birthDate'] == null ? null : DateTime.parse(json['birthDate']! as String),
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'phoneNumber': phoneNumber,
    'status': status,
    'firstName': firstName,
    'lastName': lastName,
    'sex': sex,
    'birthDate': birthDate?.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDao &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          phoneNumber == other.phoneNumber &&
          status == other.status &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          sex == other.sex &&
          birthDate == other.birthDate;

  @override
  int get hashCode =>
      id.hashCode ^
      phoneNumber.hashCode ^
      status.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      sex.hashCode ^
      birthDate.hashCode;
}
