// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'period_stats_dto.g.dart';

@JsonSerializable()
class PeriodStatsDto {
  const PeriodStatsDto({
    required this.claims,
    required this.redeemed,
    required this.expired,
    required this.redemptionRate,
  });
  
  factory PeriodStatsDto.fromJson(Map<String, Object?> json) => _$PeriodStatsDtoFromJson(json);
  
  final num claims;
  final num redeemed;
  final num expired;

  /// Redeemed / (redeemed + expired), 0 to 1. Null before any claim finishes.
  final num? redemptionRate;

  Map<String, Object?> toJson() => _$PeriodStatsDtoToJson(this);
}
