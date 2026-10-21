// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminStatsDto _$AdminStatsDtoFromJson(
  Map<String, dynamic> json,
) => AdminStatsDto(
  stores: AdminStoreStatsDto.fromJson(json['stores'] as Map<String, dynamic>),
  users: AdminUserStatsDto.fromJson(json['users'] as Map<String, dynamic>),
  offers: AdminOfferStatsDto.fromJson(json['offers'] as Map<String, dynamic>),
  claims: AdminClaimStatsDto.fromJson(json['claims'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdminStatsDtoToJson(AdminStatsDto instance) =>
    <String, dynamic>{
      'stores': instance.stores,
      'users': instance.users,
      'offers': instance.offers,
      'claims': instance.claims,
    };
