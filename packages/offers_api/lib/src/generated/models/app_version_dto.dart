// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'app_version_dto.g.dart';

@JsonSerializable()
class AppVersionDto {
  const AppVersionDto({
    required this.minVersion,
  });
  
  factory AppVersionDto.fromJson(Map<String, Object?> json) => _$AppVersionDtoFromJson(json);
  
  /// Older versions must update before they can be used.
  final String minVersion;

  Map<String, Object?> toJson() => _$AppVersionDtoToJson(this);
}
