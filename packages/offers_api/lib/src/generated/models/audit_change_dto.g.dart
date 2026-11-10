// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_change_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditChangeDto _$AuditChangeDtoFromJson(Map<String, dynamic> json) =>
    AuditChangeDto(
      field: json['field'] as String,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$AuditChangeDtoToJson(AuditChangeDto instance) =>
    <String, dynamic>{'field': instance.field, 'value': ?instance.value};
