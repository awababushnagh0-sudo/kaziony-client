// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_member_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddMemberDto _$AddMemberDtoFromJson(Map<String, dynamic> json) => AddMemberDto(
  role: StoreMemberRole.fromJson(json['role'] as String),
  name: json['name'] as String,
  phone: json['phone'] as String,
);

Map<String, dynamic> _$AddMemberDtoToJson(AddMemberDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'name': instance.name,
      'phone': instance.phone,
    };
