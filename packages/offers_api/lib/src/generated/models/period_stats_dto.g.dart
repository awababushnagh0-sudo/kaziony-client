// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PeriodStatsDto _$PeriodStatsDtoFromJson(Map<String, dynamic> json) =>
    PeriodStatsDto(
      claims: json['claims'] as num,
      redeemed: json['redeemed'] as num,
      expired: json['expired'] as num,
      redemptionRate: json['redemptionRate'] as num?,
    );

Map<String, dynamic> _$PeriodStatsDtoToJson(PeriodStatsDto instance) =>
    <String, dynamic>{
      'claims': instance.claims,
      'redeemed': instance.redeemed,
      'expired': instance.expired,
      'redemptionRate': ?instance.redemptionRate,
    };
