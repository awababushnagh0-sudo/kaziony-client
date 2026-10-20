// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatsDto _$UserStatsDtoFromJson(Map<String, dynamic> json) => UserStatsDto(
  customers: json['customers'] as num,
  merchants: json['merchants'] as num,
  newCustomersLast7Days: json['newCustomersLast7Days'] as num,
);

Map<String, dynamic> _$UserStatsDtoToJson(UserStatsDto instance) =>
    <String, dynamic>{
      'customers': instance.customers,
      'merchants': instance.merchants,
      'newCustomersLast7Days': instance.newCustomersLast7Days,
    };
