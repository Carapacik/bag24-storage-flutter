import 'package:json_annotation/json_annotation.dart';

/// An enumeration.
@JsonEnum()
enum OrderCommandStatusType(final String json) {
  @JsonValue('ALL')
  all('ALL'),
  @JsonValue('ACTIVE')
  active('ACTIVE'),
  @JsonValue('INACTIVE')
  inactive('INACTIVE');

  factory fromJson(String json) => values.firstWhere((e) => e.json == json);
}
