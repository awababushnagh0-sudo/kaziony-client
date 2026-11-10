// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'system_jobs_summary_dto.g.dart';

@JsonSerializable()
class SystemJobsSummaryDto {
  const SystemJobsSummaryDto({
    required this.total,
    required this.failing,
    required this.running,
  });
  
  factory SystemJobsSummaryDto.fromJson(Map<String, Object?> json) => _$SystemJobsSummaryDtoFromJson(json);
  
  final num total;

  /// Jobs whose last run failed.
  final num failing;
  final num running;

  Map<String, Object?> toJson() => _$SystemJobsSummaryDtoToJson(this);
}
