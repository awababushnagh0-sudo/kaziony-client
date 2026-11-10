// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'system_query_dto.g.dart';

@JsonSerializable()
class SystemQueryDto {
  const SystemQueryDto({
    required this.query,
    required this.calls,
    required this.totalMs,
    required this.meanMs,
    required this.rows,
  });
  
  factory SystemQueryDto.fromJson(Map<String, Object?> json) => _$SystemQueryDtoFromJson(json);
  
  /// With $1, $2 for the values: never customers' data.
  final String query;
  final num calls;
  final num totalMs;
  final num meanMs;
  final num rows;

  Map<String, Object?> toJson() => _$SystemQueryDtoToJson(this);
}
