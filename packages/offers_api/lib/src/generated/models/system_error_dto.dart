// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'system_error_dto.g.dart';

@JsonSerializable()
class SystemErrorDto {
  const SystemErrorDto({
    required this.fingerprint,
    required this.name,
    required this.message,
    required this.method,
    required this.route,
    required this.statusCode,
    required this.count,
    required this.firstSeenAt,
    required this.lastSeenAt,
    required this.lastRequestId,
    required this.stack,
    required this.instanceCount,
  });
  
  factory SystemErrorDto.fromJson(Map<String, Object?> json) => _$SystemErrorDtoFromJson(json);
  
  final String fingerprint;
  final String name;
  final String message;
  final String method;
  final String route;
  final num statusCode;

  /// Times it happened in the last 24 hours (since the instance started).
  final num count;
  final DateTime firstSeenAt;
  final DateTime lastSeenAt;

  /// Finds the last occurrence's log lines.
  final String? lastRequestId;
  final String? stack;

  /// Instances it happened on.
  final num instanceCount;

  Map<String, Object?> toJson() => _$SystemErrorDtoToJson(this);
}
