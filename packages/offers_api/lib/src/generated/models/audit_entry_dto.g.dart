// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntryDto _$AuditEntryDtoFromJson(Map<String, dynamic> json) =>
    AuditEntryDto(
      id: json['id'] as String,
      action: json['action'] as String,
      actor: json['actor'] == null
          ? null
          : AuditActorDto.fromJson(json['actor'] as Map<String, dynamic>),
      targetId: json['targetId'] as String?,
      targetLabel: json['targetLabel'] as String?,
      changes: (json['changes'] as List<dynamic>)
          .map((e) => AuditChangeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      requestId: json['requestId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AuditEntryDtoToJson(AuditEntryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'action': instance.action,
      'actor': ?instance.actor,
      'targetId': ?instance.targetId,
      'targetLabel': ?instance.targetLabel,
      'changes': instance.changes,
      'requestId': ?instance.requestId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
