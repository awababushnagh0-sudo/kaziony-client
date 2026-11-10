// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_actor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditActorDto _$AuditActorDtoFromJson(Map<String, dynamic> json) =>
    AuditActorDto(
      role: UserRole.fromJson(json['role'] as String),
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AuditActorDtoToJson(AuditActorDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'id': instance.id,
      'name': ?instance.name,
      'email': ?instance.email,
    };
