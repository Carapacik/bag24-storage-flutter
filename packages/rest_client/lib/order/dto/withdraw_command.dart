import 'package:json_annotation/json_annotation.dart';

part 'withdraw_command.g.dart';

@JsonSerializable()
class const WithdrawCommand({
  /// Идентификаторы багажа для выдачи из кх
  required final List<String> luggageIds,
}) {
  factory fromJson(Map<String, Object?> json) => _$WithdrawCommandFromJson(json);

  Map<String, Object?> toJson() => _$WithdrawCommandToJson(this);
}
