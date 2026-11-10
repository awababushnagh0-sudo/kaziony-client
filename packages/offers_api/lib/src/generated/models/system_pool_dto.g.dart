// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_pool_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemPoolDto _$SystemPoolDtoFromJson(Map<String, dynamic> json) =>
    SystemPoolDto(
      total: json['total'] as num,
      idle: json['idle'] as num,
      waiting: json['waiting'] as num,
      max: json['max'] as num,
    );

Map<String, dynamic> _$SystemPoolDtoToJson(SystemPoolDto instance) =>
    <String, dynamic>{
      'total': instance.total,
      'idle': instance.idle,
      'waiting': instance.waiting,
      'max': instance.max,
    };
