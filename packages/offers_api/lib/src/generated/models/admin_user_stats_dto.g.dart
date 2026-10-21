// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUserStatsDto _$AdminUserStatsDtoFromJson(Map<String, dynamic> json) =>
    AdminUserStatsDto(
      customers: json['customers'] as num,
      merchants: json['merchants'] as num,
      newCustomersLast7Days: json['newCustomersLast7Days'] as num,
    );

Map<String, dynamic> _$AdminUserStatsDtoToJson(AdminUserStatsDto instance) =>
    <String, dynamic>{
      'customers': instance.customers,
      'merchants': instance.merchants,
      'newCustomersLast7Days': instance.newCustomersLast7Days,
    };
