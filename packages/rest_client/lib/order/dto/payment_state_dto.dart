import 'package:json_annotation/json_annotation.dart';

/// An enumeration.
@JsonEnum()
enum PaymentStateDto(final String? json) {
  @JsonValue('CREATED')
  created('CREATED'),
  @JsonValue('IN_PROGRESS')
  inProgress('IN_PROGRESS'),
  @JsonValue('SUCCEEDED')
  succeeded('SUCCEEDED'),
  @JsonValue('FAILED')
  failed('FAILED'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  factory fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => $unknown);
}
