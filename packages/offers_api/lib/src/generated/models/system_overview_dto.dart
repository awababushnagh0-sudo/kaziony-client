// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'system_checks_dto.dart';
import 'system_instance_dto.dart';
import 'system_jobs_summary_dto.dart';
import 'system_traffic_summary_dto.dart';

part 'system_overview_dto.g.dart';

@JsonSerializable()
class SystemOverviewDto {
  const SystemOverviewDto({
    required this.checkedAt,
    required this.checks,
    required this.instances,
    required this.traffic,
    required this.jobs,
    required this.errorGroups,
  });
  
  factory SystemOverviewDto.fromJson(Map<String, Object?> json) => _$SystemOverviewDtoFromJson(json);
  
  final DateTime checkedAt;
  final SystemChecksDto checks;
  final List<SystemInstanceDto> instances;
  final SystemTrafficSummaryDto traffic;
  final SystemJobsSummaryDto jobs;

  /// Kinds of server errors seen in the last 24 hours.
  final num errorGroups;

  Map<String, Object?> toJson() => _$SystemOverviewDtoToJson(this);
}
