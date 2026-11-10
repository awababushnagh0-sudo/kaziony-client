// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'system_job_dto.dart';

part 'system_job_list_dto.g.dart';

@JsonSerializable()
class SystemJobListDto {
  const SystemJobListDto({
    required this.items,
  });
  
  factory SystemJobListDto.fromJson(Map<String, Object?> json) => _$SystemJobListDtoFromJson(json);
  
  final List<SystemJobDto> items;

  Map<String, Object?> toJson() => _$SystemJobListDtoToJson(this);
}
