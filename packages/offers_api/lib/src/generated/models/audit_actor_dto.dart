// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'user_role.dart';

part 'audit_actor_dto.g.dart';

@JsonSerializable()
class AuditActorDto {
  const AuditActorDto({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
  });
  
  factory AuditActorDto.fromJson(Map<String, Object?> json) => _$AuditActorDtoFromJson(json);
  
  final UserRole role;
  final String id;
  final String? name;
  final String? email;

  Map<String, Object?> toJson() => _$AuditActorDtoToJson(this);
}
