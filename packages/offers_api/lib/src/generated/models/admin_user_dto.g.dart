// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUserDto _$AdminUserDtoFromJson(Map<String, dynamic> json) => AdminUserDto(
  role: UserRole.fromJson(json['role'] as String),
  id: json['id'] as String,
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  mustChangePassword: json['mustChangePassword'] as bool,
  contactPhone: json['contactPhone'] as String?,
  isActive: json['isActive'] as bool,
  noShowCount: json['noShowCount'] as num,
  claimBannedUntil: json['claimBannedUntil'] == null
      ? null
      : DateTime.parse(json['claimBannedUntil'] as String),
  lastLoginAt: json['lastLoginAt'] == null
      ? null
      : DateTime.parse(json['lastLoginAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AdminUserDtoToJson(AdminUserDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'id': instance.id,
      'name': ?instance.name,
      'email': ?instance.email,
      'phone': ?instance.phone,
      'avatarUrl': ?instance.avatarUrl,
      'mustChangePassword': instance.mustChangePassword,
      'contactPhone': ?instance.contactPhone,
      'isActive': instance.isActive,
      'noShowCount': instance.noShowCount,
      'claimBannedUntil': ?instance.claimBannedUntil?.toIso8601String(),
      'lastLoginAt': ?instance.lastLoginAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
