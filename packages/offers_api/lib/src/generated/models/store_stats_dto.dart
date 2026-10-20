// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'period_stats_dto.dart';
import 'top_offer_dto.dart';

part 'store_stats_dto.g.dart';

@JsonSerializable()
class StoreStatsDto {
  const StoreStatsDto({
    required this.liveOffers,
    required this.activeReservations,
    required this.today,
    required this.last30Days,
    required this.topOffers,
  });
  
  factory StoreStatsDto.fromJson(Map<String, Object?> json) => _$StoreStatsDtoFromJson(json);
  
  /// Offers customers can claim right now.
  final num liveOffers;

  /// Customers on their way (reserved, not expired).
  final num activeReservations;

  /// Since midnight, Libya time.
  final PeriodStatsDto today;
  final PeriodStatsDto last30Days;

  /// Most redeemed offers in the last 30 days.
  final List<TopOfferDto> topOffers;

  Map<String, Object?> toJson() => _$StoreStatsDtoToJson(this);
}
