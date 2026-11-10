// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'app_settings_dto.g.dart';

@JsonSerializable()
class AppSettingsDto {
  const AppSettingsDto({
    required this.browseRadiusKm,
    required this.holdMinutes,
  });
  
  factory AppSettingsDto.fromJson(Map<String, Object?> json) => _$AppSettingsDtoFromJson(json);
  
  /// Customers see offers from stores this close to them, in km.
  final num browseRadiusKm;

  /// How long a reservation is held for the customer to come, in minutes,.
  /// unless the offer ends first. Reservations made before a change keep.
  /// theirs.
  final num holdMinutes;

  Map<String, Object?> toJson() => _$AppSettingsDtoToJson(this);
}
