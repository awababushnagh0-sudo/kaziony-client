// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'user_dto.dart';

part 'auth_response_dto.g.dart';

@JsonSerializable()
class AuthResponseDto {
  const AuthResponseDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });
  
  factory AuthResponseDto.fromJson(Map<String, Object?> json) => _$AuthResponseDtoFromJson(json);
  
  final String accessToken;
  final String refreshToken;

  /// Access token lifetime in seconds.
  final num expiresIn;
  final UserDto user;

  Map<String, Object?> toJson() => _$AuthResponseDtoToJson(this);
}
