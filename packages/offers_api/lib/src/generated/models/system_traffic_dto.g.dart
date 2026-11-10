// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_traffic_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemTrafficDto _$SystemTrafficDtoFromJson(Map<String, dynamic> json) =>
    SystemTrafficDto(
      minutes: json['minutes'] as num,
      series: (json['series'] as List<dynamic>)
          .map((e) => SystemTrafficPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      routes: (json['routes'] as List<dynamic>)
          .map((e) => SystemRouteDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SystemTrafficDtoToJson(SystemTrafficDto instance) =>
    <String, dynamic>{
      'minutes': instance.minutes,
      'series': instance.series,
      'routes': instance.routes,
    };
