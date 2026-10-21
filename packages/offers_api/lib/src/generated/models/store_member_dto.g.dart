// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreMemberDto _$StoreMemberDtoFromJson(Map<String, dynamic> json) =>
    StoreMemberDto(
      role: StoreMemberRole.fromJson(json['role'] as String),
      userId: json['userId'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      branchId: json['branchId'] as String?,
      isActive: json['isActive'] as bool,
      mustChangePassword: json['mustChangePassword'] as bool,
    );

Map<String, dynamic> _$StoreMemberDtoToJson(StoreMemberDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'userId': instance.userId,
      'name': ?instance.name,
      'phone': ?instance.phone,
      'branchId': ?instance.branchId,
      'isActive': instance.isActive,
      'mustChangePassword': instance.mustChangePassword,
    };
