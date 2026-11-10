// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'service_status.dart';

part 'system_check_dto.g.dart';

@JsonSerializable()
class SystemCheckDto {
  const SystemCheckDto({
    required this.status,
    required this.latencyMs,
    required this.detail,
  });
  
  factory SystemCheckDto.fromJson(Map<String, Object?> json) => _$SystemCheckDtoFromJson(json);
  
  final ServiceStatus status;

  /// Round trip in milliseconds; null unless up.
  final num? latencyMs;

  /// Why it's down or off.
  final String? detail;

  Map<String, Object?> toJson() => _$SystemCheckDtoToJson(this);
}
