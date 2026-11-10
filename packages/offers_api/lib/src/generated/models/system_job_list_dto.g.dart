// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_job_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemJobListDto _$SystemJobListDtoFromJson(Map<String, dynamic> json) =>
    SystemJobListDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => SystemJobDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SystemJobListDtoToJson(SystemJobListDto instance) =>
    <String, dynamic>{'items': instance.items};
