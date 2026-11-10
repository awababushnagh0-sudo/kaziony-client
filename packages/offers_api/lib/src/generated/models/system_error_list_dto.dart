// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'system_error_dto.dart';

part 'system_error_list_dto.g.dart';

@JsonSerializable()
class SystemErrorListDto {
  const SystemErrorListDto({
    required this.items,
  });
  
  factory SystemErrorListDto.fromJson(Map<String, Object?> json) => _$SystemErrorListDtoFromJson(json);
  
  /// Most recent first.
  final List<SystemErrorDto> items;

  Map<String, Object?> toJson() => _$SystemErrorListDtoToJson(this);
}
