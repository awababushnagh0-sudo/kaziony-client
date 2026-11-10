// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_jobs_summary_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemJobsSummaryDto _$SystemJobsSummaryDtoFromJson(
  Map<String, dynamic> json,
) => SystemJobsSummaryDto(
  total: json['total'] as num,
  failing: json['failing'] as num,
  running: json['running'] as num,
);

Map<String, dynamic> _$SystemJobsSummaryDtoToJson(
  SystemJobsSummaryDto instance,
) => <String, dynamic>{
  'total': instance.total,
  'failing': instance.failing,
  'running': instance.running,
};
