// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'system_table_dto.g.dart';

@JsonSerializable()
class SystemTableDto {
  const SystemTableDto({
    required this.name,
    required this.rows,
    required this.totalBytes,
    required this.seqScans,
    required this.indexScans,
    required this.deadRows,
    required this.lastVacuumAt,
  });
  
  factory SystemTableDto.fromJson(Map<String, Object?> json) => _$SystemTableDtoFromJson(json);
  
  final String name;

  /// Estimated.
  final num rows;

  /// With indexes.
  final num totalBytes;
  final num seqScans;
  final num indexScans;

  /// Removed rows waiting for vacuum.
  final num deadRows;
  final DateTime? lastVacuumAt;

  Map<String, Object?> toJson() => _$SystemTableDtoToJson(this);
}
