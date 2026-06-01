// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'init_command.g.dart';

@JsonSerializable()
class InitCommand {
  const InitCommand({required this.phoneNumber, this.useTelegram = true});

  factory InitCommand.fromJson(Map<String, Object?> json) => _$InitCommandFromJson(json);

  /// User phone number
  final String phoneNumber;

  /// Use Telegram
  final bool useTelegram;

  Map<String, Object?> toJson() => _$InitCommandToJson(this);
}
