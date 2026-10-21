// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_claim_stats_dto.g.dart';

@JsonSerializable()
class AdminClaimStatsDto {
  const AdminClaimStatsDto({
    required this.total,
    required this.redeemed,
    required this.expired,
    required this.last7Days,
    required this.redemptionRate,
  });
  
  factory AdminClaimStatsDto.fromJson(Map<String, Object?> json) => _$AdminClaimStatsDtoFromJson(json);
  
  final num total;
  final num redeemed;
  final num expired;

  /// Claims made in the last 7 days.
  final num last7Days;

  /// Redeemed / (redeemed + expired), 0 to 1. Null before any claim finishes.
  final num? redemptionRate;

  Map<String, Object?> toJson() => _$AdminClaimStatsDtoToJson(this);
}
