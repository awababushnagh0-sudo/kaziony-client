// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'user_role.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  const UserDto({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.mustChangePassword,
  });
  
  factory UserDto.fromJson(Map<String, Object?> json) => _$UserDtoFromJson(json);
  
  final UserRole role;
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatarUrl;

  /// True for merchants who still have the temporary password from onboarding.
  final bool mustChangePassword;

  Map<String, Object?> toJson() => _$UserDtoToJson(this);
}
