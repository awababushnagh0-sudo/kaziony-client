// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'reset_password_response_dto.g.dart';

@JsonSerializable()
class ResetPasswordResponseDto {
  const ResetPasswordResponseDto({
    required this.temporaryPassword,
  });
  
  factory ResetPasswordResponseDto.fromJson(Map<String, Object?> json) => _$ResetPasswordResponseDtoFromJson(json);
  
  /// Shown only once. The user must change it on next login.
  final String temporaryPassword;

  Map<String, Object?> toJson() => _$ResetPasswordResponseDtoToJson(this);
}
