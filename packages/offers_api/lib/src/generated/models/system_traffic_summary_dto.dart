// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'system_traffic_summary_dto.g.dart';

@JsonSerializable()
class SystemTrafficSummaryDto {
  const SystemTrafficSummaryDto({
    required this.requestsPerMinute,
    required this.serverErrors,
    required this.errorRate,
    required this.p95Ms,
  });
  
  factory SystemTrafficSummaryDto.fromJson(Map<String, Object?> json) => _$SystemTrafficSummaryDtoFromJson(json);
  
  /// Over the last 5 minutes, all instances together.
  final num requestsPerMinute;

  /// Our errors (5xx) in the last 5 minutes.
  final num serverErrors;

  /// Server errors / requests, 0 to 1. Null without requests.
  final num? errorRate;
  final num? p95Ms;

  Map<String, Object?> toJson() => _$SystemTrafficSummaryDtoToJson(this);
}
