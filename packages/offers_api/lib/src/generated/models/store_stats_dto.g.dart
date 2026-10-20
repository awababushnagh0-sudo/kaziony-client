// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreStatsDto _$StoreStatsDtoFromJson(Map<String, dynamic> json) =>
    StoreStatsDto(
      liveOffers: json['liveOffers'] as num,
      activeReservations: json['activeReservations'] as num,
      today: PeriodStatsDto.fromJson(json['today'] as Map<String, dynamic>),
      last30Days: PeriodStatsDto.fromJson(
        json['last30Days'] as Map<String, dynamic>,
      ),
      topOffers: (json['topOffers'] as List<dynamic>)
          .map((e) => TopOfferDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreStatsDtoToJson(StoreStatsDto instance) =>
    <String, dynamic>{
      'liveOffers': instance.liveOffers,
      'activeReservations': instance.activeReservations,
      'today': instance.today,
      'last30Days': instance.last30Days,
      'topOffers': instance.topOffers,
    };
