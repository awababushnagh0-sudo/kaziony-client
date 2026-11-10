// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_traffic_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemTrafficSummaryDto _$SystemTrafficSummaryDtoFromJson(
  Map<String, dynamic> json,
) => SystemTrafficSummaryDto(
  requestsPerMinute: json['requestsPerMinute'] as num,
  serverErrors: json['serverErrors'] as num,
  errorRate: json['errorRate'] as num?,
  p95Ms: json['p95Ms'] as num?,
);

Map<String, dynamic> _$SystemTrafficSummaryDtoToJson(
  SystemTrafficSummaryDto instance,
) => <String, dynamic>{
  'requestsPerMinute': instance.requestsPerMinute,
  'serverErrors': instance.serverErrors,
  'errorRate': ?instance.errorRate,
  'p95Ms': ?instance.p95Ms,
};
