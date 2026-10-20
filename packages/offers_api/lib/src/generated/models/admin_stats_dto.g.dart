// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminStatsDto _$AdminStatsDtoFromJson(Map<String, dynamic> json) =>
    AdminStatsDto(
      stores: StoreStatsDto.fromJson(json['stores'] as Map<String, dynamic>),
      users: UserStatsDto.fromJson(json['users'] as Map<String, dynamic>),
      offers: OfferStatsDto.fromJson(json['offers'] as Map<String, dynamic>),
      claims: ClaimStatsDto.fromJson(json['claims'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdminStatsDtoToJson(AdminStatsDto instance) =>
    <String, dynamic>{
      'stores': instance.stores,
      'users': instance.users,
      'offers': instance.offers,
      'claims': instance.claims,
    };
