// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_overview_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemOverviewDto _$SystemOverviewDtoFromJson(Map<String, dynamic> json) =>
    SystemOverviewDto(
      checkedAt: DateTime.parse(json['checkedAt'] as String),
      checks: SystemChecksDto.fromJson(json['checks'] as Map<String, dynamic>),
      instances: (json['instances'] as List<dynamic>)
          .map((e) => SystemInstanceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      traffic: SystemTrafficSummaryDto.fromJson(
        json['traffic'] as Map<String, dynamic>,
      ),
      jobs: SystemJobsSummaryDto.fromJson(json['jobs'] as Map<String, dynamic>),
      errorGroups: json['errorGroups'] as num,
    );

Map<String, dynamic> _$SystemOverviewDtoToJson(SystemOverviewDto instance) =>
    <String, dynamic>{
      'checkedAt': instance.checkedAt.toIso8601String(),
      'checks': instance.checks,
      'instances': instance.instances,
      'traffic': instance.traffic,
      'jobs': instance.jobs,
      'errorGroups': instance.errorGroups,
    };
