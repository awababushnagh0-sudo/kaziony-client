// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'app_version_dto.dart';

part 'app_config_dto.g.dart';

@JsonSerializable()
class AppConfigDto {
  const AppConfigDto({
    required this.business,
    required this.customer,
    required this.admin,
  });
  
  factory AppConfigDto.fromJson(Map<String, Object?> json) => _$AppConfigDtoFromJson(json);
  
  final AppVersionDto business;
  final AppVersionDto customer;
  final AppVersionDto admin;

  Map<String, Object?> toJson() => _$AppConfigDtoToJson(this);
}
