// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_claim_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminClaimStatsDto _$AdminClaimStatsDtoFromJson(Map<String, dynamic> json) =>
    AdminClaimStatsDto(
      total: json['total'] as num,
      redeemed: json['redeemed'] as num,
      expired: json['expired'] as num,
      last7Days: json['last7Days'] as num,
      redemptionRate: json['redemptionRate'] as num?,
    );

Map<String, dynamic> _$AdminClaimStatsDtoToJson(AdminClaimStatsDto instance) =>
    <String, dynamic>{
      'total': instance.total,
      'redeemed': instance.redeemed,
      'expired': instance.expired,
      'last7Days': instance.last7Days,
      'redemptionRate': instance.redemptionRate,
    };
