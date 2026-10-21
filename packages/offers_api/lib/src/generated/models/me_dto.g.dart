// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeDto _$MeDtoFromJson(Map<String, dynamic> json) => MeDto(
  role: UserRole.fromJson(json['role'] as String),
  id: json['id'] as String,
  name: json['name'] as String?,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  mustChangePassword: json['mustChangePassword'] as bool,
  contactPhone: json['contactPhone'] as String?,
  memberships: (json['memberships'] as List<dynamic>)
      .map((e) => MembershipDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$MeDtoToJson(MeDto instance) => <String, dynamic>{
  'role': instance.role,
  'id': instance.id,
  'name': ?instance.name,
  'email': ?instance.email,
  'phone': ?instance.phone,
  'avatarUrl': ?instance.avatarUrl,
  'mustChangePassword': instance.mustChangePassword,
  'contactPhone': ?instance.contactPhone,
  'memberships': instance.memberships,
};
