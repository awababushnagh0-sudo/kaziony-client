// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_offer_stats_dto.g.dart';

@JsonSerializable()
class AdminOfferStatsDto {
  const AdminOfferStatsDto({
    required this.live,
    required this.total,
  });
  
  factory AdminOfferStatsDto.fromJson(Map<String, Object?> json) => _$AdminOfferStatsDtoFromJson(json);
  
  /// Active and not yet ended.
  final num live;
  final num total;

  Map<String, Object?> toJson() => _$AdminOfferStatsDtoToJson(this);
}
