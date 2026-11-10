// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_entry_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditEntryListDto _$AuditEntryListDtoFromJson(Map<String, dynamic> json) =>
    AuditEntryListDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => AuditEntryDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuditEntryListDtoToJson(AuditEntryListDto instance) =>
    <String, dynamic>{'items': instance.items, 'meta': instance.meta};
