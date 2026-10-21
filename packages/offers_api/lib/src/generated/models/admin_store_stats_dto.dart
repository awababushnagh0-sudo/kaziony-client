// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_store_stats_dto.g.dart';

@JsonSerializable()
class AdminStoreStatsDto {
  const AdminStoreStatsDto({
    required this.total,
    required this.active,
  });
  
  factory AdminStoreStatsDto.fromJson(Map<String, Object?> json) => _$AdminStoreStatsDtoFromJson(json);
  
  final num total;
  final num active;

  Map<String, Object?> toJson() => _$AdminStoreStatsDtoToJson(this);
}
