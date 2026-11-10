// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'system_route_dto.g.dart';

@JsonSerializable()
class SystemRouteDto {
  const SystemRouteDto({
    required this.method,
    required this.route,
    required this.requests,
    required this.clientErrors,
    required this.serverErrors,
    required this.avgMs,
    required this.p50Ms,
    required this.p95Ms,
    required this.p99Ms,
  });
  
  factory SystemRouteDto.fromJson(Map<String, Object?> json) => _$SystemRouteDtoFromJson(json);
  
  final String method;

  /// As written in the code.
  final String route;
  final num requests;

  /// 4xx: the app or the person asked for something wrong.
  final num clientErrors;

  /// 5xx: our fault.
  final num serverErrors;
  final num? avgMs;
  final num? p50Ms;
  final num? p95Ms;
  final num? p99Ms;

  Map<String, Object?> toJson() => _$SystemRouteDtoToJson(this);
}
