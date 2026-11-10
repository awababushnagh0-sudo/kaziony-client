// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_checks_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemChecksDto _$SystemChecksDtoFromJson(Map<String, dynamic> json) =>
    SystemChecksDto(
      database: SystemCheckDto.fromJson(
        json['database'] as Map<String, dynamic>,
      ),
      redis: SystemCheckDto.fromJson(json['redis'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SystemChecksDtoToJson(SystemChecksDto instance) =>
    <String, dynamic>{'database': instance.database, 'redis': instance.redis};
