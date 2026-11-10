// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'audit_change_dto.g.dart';

@JsonSerializable()
class AuditChangeDto {
  const AuditChangeDto({
    required this.field,
    required this.value,
  });
  
  factory AuditChangeDto.fromJson(Map<String, Object?> json) => _$AuditChangeDtoFromJson(json);
  
  /// Dotted for nested fields.
  final String field;
  final String? value;

  Map<String, Object?> toJson() => _$AuditChangeDtoToJson(this);
}
