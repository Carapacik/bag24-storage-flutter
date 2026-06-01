import 'package:json_annotation/json_annotation.dart';

/// An enumeration.
@JsonEnum()
enum OrderStatusDto(final String? json) {
  @JsonValue('PENDING')
  pending('PENDING'),
  @JsonValue('CREATED')
  created('CREATED'),
  @JsonValue('PAYING')
  paying('PAYING'),
  @JsonValue('PAID')
  paid('PAID'),
  @JsonValue('DEPOSITING')
  depositing('DEPOSITING'),
  @JsonValue('DEPOSITED')
  deposited('DEPOSITED'),
  @JsonValue('WITHDRAWING')
  withdrawing('WITHDRAWING'),
  @JsonValue('WITHDRAWN')
  withdrawn('WITHDRAWN'),
  @JsonValue('PARTIALLY_WITHDRAWN')
  partiallyWithdrawn('PARTIALLY_WITHDRAWN'),
  @JsonValue('DECLINED')
  declined('DECLINED'),
  @JsonValue('DELETED')
  deleted('DELETED'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  factory fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => $unknown);
}
