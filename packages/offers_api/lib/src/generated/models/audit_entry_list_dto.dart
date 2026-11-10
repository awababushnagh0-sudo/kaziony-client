// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'audit_entry_dto.dart';
import 'page_meta_dto.dart';

part 'audit_entry_list_dto.g.dart';

@JsonSerializable()
class AuditEntryListDto {
  const AuditEntryListDto({
    required this.items,
    required this.meta,
  });
  
  factory AuditEntryListDto.fromJson(Map<String, Object?> json) => _$AuditEntryListDtoFromJson(json);
  
  final List<AuditEntryDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$AuditEntryListDtoToJson(this);
}
