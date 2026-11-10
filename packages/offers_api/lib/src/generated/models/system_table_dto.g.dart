// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_table_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemTableDto _$SystemTableDtoFromJson(Map<String, dynamic> json) =>
    SystemTableDto(
      name: json['name'] as String,
      rows: json['rows'] as num,
      totalBytes: json['totalBytes'] as num,
      seqScans: json['seqScans'] as num,
      indexScans: json['indexScans'] as num,
      deadRows: json['deadRows'] as num,
      lastVacuumAt: json['lastVacuumAt'] == null
          ? null
          : DateTime.parse(json['lastVacuumAt'] as String),
    );

Map<String, dynamic> _$SystemTableDtoToJson(SystemTableDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rows': instance.rows,
      'totalBytes': instance.totalBytes,
      'seqScans': instance.seqScans,
      'indexScans': instance.indexScans,
      'deadRows': instance.deadRows,
      'lastVacuumAt': ?instance.lastVacuumAt?.toIso8601String(),
    };
