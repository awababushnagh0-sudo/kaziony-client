// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'login_dto.g.dart';

@JsonSerializable()
class LoginDto {
  const LoginDto({
    required this.identifier,
    required this.password,
  });
  
  factory LoginDto.fromJson(Map<String, Object?> json) => _$LoginDtoFromJson(json);
  
  /// Phone number (merchants) or email (admins).
  final String identifier;
  final String password;

  Map<String, Object?> toJson() => _$LoginDtoToJson(this);
}
