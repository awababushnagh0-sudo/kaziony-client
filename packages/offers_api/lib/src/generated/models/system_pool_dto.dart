// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'system_pool_dto.g.dart';

@JsonSerializable()
class SystemPoolDto {
  const SystemPoolDto({
    required this.total,
    required this.idle,
    required this.waiting,
    required this.max,
  });
  
  factory SystemPoolDto.fromJson(Map<String, Object?> json) => _$SystemPoolDtoFromJson(json);
  
  /// Connections open now.
  final num total;
  final num idle;

  /// Queries waiting for a connection: above 0 for long, the pool is too small.
  final num waiting;
  final num max;

  Map<String, Object?> toJson() => _$SystemPoolDtoToJson(this);
}
