// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'user_role.dart';

part 'admin_user_dto.g.dart';

@JsonSerializable()
class AdminUserDto {
  const AdminUserDto({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.mustChangePassword,
    required this.contactPhone,
    required this.isActive,
    required this.noShowCount,
    required this.claimBannedUntil,
    required this.lastLoginAt,
    required this.createdAt,
  });
  
  factory AdminUserDto.fromJson(Map<String, Object?> json) => _$AdminUserDtoFromJson(json);
  
  final UserRole role;
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatarUrl;

  /// True for merchants who still have the temporary password from onboarding.
  final bool mustChangePassword;
  final String? contactPhone;
  final bool isActive;
  final num noShowCount;
  final DateTime? claimBannedUntil;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$AdminUserDtoToJson(this);
}
