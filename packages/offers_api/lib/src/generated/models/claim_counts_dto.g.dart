// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_counts_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimCountsDto _$ClaimCountsDtoFromJson(Map<String, dynamic> json) =>
    ClaimCountsDto(
      reserved: json['reserved'] as num,
      redeemed: json['redeemed'] as num,
      expired: json['expired'] as num,
      cancelled: json['cancelled'] as num,
    );

Map<String, dynamic> _$ClaimCountsDtoToJson(ClaimCountsDto instance) =>
    <String, dynamic>{
      'reserved': instance.reserved,
      'redeemed': instance.redeemed,
      'expired': instance.expired,
      'cancelled': instance.cancelled,
    };
