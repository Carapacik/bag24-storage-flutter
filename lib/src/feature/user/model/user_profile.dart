import 'package:bag24/src/core/components/prefs_storage/user/dao/user_dao.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/user/dto/user_dto.dart';

@immutable
class const UserProfile({
  required final String id,
  required final String phoneNumber,
  required final UserStatus status,
  final String? firstName,
  final String? lastName,
  final UserSexType sex = UserSexType.male,
  final DateTime? birthDate,
}) {
  factory decode(UserDto dto) => UserProfile(
    id: dto.id,
    phoneNumber: dto.phoneNumber,
    status: dto.status,
    firstName: dto.firstName,
    lastName: dto.lastName,
    sex: UserSexType.fromString(dto.sex?.json),
    birthDate: dto.birthDate,
  );

  factory decodeDao(UserDao dao) => UserProfile(
    id: dao.id,
    phoneNumber: dao.phoneNumber,
    status: UserStatus.fromJson(dao.status),
    firstName: dao.firstName,
    lastName: dao.lastName,
    sex: UserSexType.fromString(dao.sex),
    birthDate: dao.birthDate,
  );

  static UserDao encodeDao(UserProfile data) => UserDao(
    id: data.id,
    phoneNumber: data.phoneNumber,
    status: data.status.json,
    firstName: data.firstName,
    lastName: data.lastName,
    sex: data.sex.json,
    birthDate: data.birthDate,
  );

  UserProfile copyWith({
    String? id,
    String? phoneNumber,
    UserStatus? status,
    String? firstName,
    String? lastName,
    UserSexType? sex,
    DateTime? birthDate,
  }) => UserProfile(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    status: status ?? this.status,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    sex: sex ?? this.sex,
    birthDate: birthDate ?? this.birthDate,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
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

enum UserSexType(final String json) {
  male('MALE'),
  female('FEMALE');

  factory fromString(String? json) => values.firstWhere((e) => e.json == json, orElse: () => UserSexType.male);
}
