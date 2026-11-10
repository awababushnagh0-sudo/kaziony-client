// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_route_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemRouteDto _$SystemRouteDtoFromJson(Map<String, dynamic> json) =>
    SystemRouteDto(
      method: json['method'] as String,
      route: json['route'] as String,
      requests: json['requests'] as num,
      clientErrors: json['clientErrors'] as num,
      serverErrors: json['serverErrors'] as num,
      avgMs: json['avgMs'] as num?,
      p50Ms: json['p50Ms'] as num?,
      p95Ms: json['p95Ms'] as num?,
      p99Ms: json['p99Ms'] as num?,
    );

Map<String, dynamic> _$SystemRouteDtoToJson(SystemRouteDto instance) =>
    <String, dynamic>{
      'method': instance.method,
      'route': instance.route,
      'requests': instance.requests,
      'clientErrors': instance.clientErrors,
      'serverErrors': instance.serverErrors,
      'avgMs': ?instance.avgMs,
      'p50Ms': ?instance.p50Ms,
      'p95Ms': ?instance.p95Ms,
      'p99Ms': ?instance.p99Ms,
    };
