// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'system_traffic_point_dto.g.dart';

@JsonSerializable()
class SystemTrafficPointDto {
  const SystemTrafficPointDto({
    required this.at,
    required this.requests,
    required this.clientErrors,
    required this.serverErrors,
    required this.p50Ms,
    required this.p95Ms,
    required this.p99Ms,
  });
  
  factory SystemTrafficPointDto.fromJson(Map<String, Object?> json) => _$SystemTrafficPointDtoFromJson(json);
  
  /// Start of the minute.
  final DateTime at;
  final num requests;
  final num clientErrors;
  final num serverErrors;
  final num? p50Ms;
  final num? p95Ms;
  final num? p99Ms;

  Map<String, Object?> toJson() => _$SystemTrafficPointDtoToJson(this);
}
