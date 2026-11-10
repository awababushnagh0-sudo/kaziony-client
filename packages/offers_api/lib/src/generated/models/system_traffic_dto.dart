// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'system_route_dto.dart';
import 'system_traffic_point_dto.dart';

part 'system_traffic_dto.g.dart';

@JsonSerializable()
class SystemTrafficDto {
  const SystemTrafficDto({
    required this.minutes,
    required this.series,
    required this.routes,
  });
  
  factory SystemTrafficDto.fromJson(Map<String, Object?> json) => _$SystemTrafficDtoFromJson(json);
  
  final num minutes;

  /// Every minute of the window, oldest first.
  final List<SystemTrafficPointDto> series;

  /// Busiest first.
  final List<SystemRouteDto> routes;

  Map<String, Object?> toJson() => _$SystemTrafficDtoToJson(this);
}
