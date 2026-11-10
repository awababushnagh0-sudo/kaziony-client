// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_traffic_point_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemTrafficPointDto _$SystemTrafficPointDtoFromJson(
  Map<String, dynamic> json,
) => SystemTrafficPointDto(
  at: DateTime.parse(json['at'] as String),
  requests: json['requests'] as num,
  clientErrors: json['clientErrors'] as num,
  serverErrors: json['serverErrors'] as num,
  p50Ms: json['p50Ms'] as num?,
  p95Ms: json['p95Ms'] as num?,
  p99Ms: json['p99Ms'] as num?,
);

Map<String, dynamic> _$SystemTrafficPointDtoToJson(
  SystemTrafficPointDto instance,
) => <String, dynamic>{
  'at': instance.at.toIso8601String(),
  'requests': instance.requests,
  'clientErrors': instance.clientErrors,
  'serverErrors': instance.serverErrors,
  'p50Ms': ?instance.p50Ms,
  'p95Ms': ?instance.p95Ms,
  'p99Ms': ?instance.p99Ms,
};
