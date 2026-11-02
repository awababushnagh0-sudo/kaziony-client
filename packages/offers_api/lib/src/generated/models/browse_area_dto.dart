// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'browse_area_dto.g.dart';

@JsonSerializable()
class BrowseAreaDto {
  const BrowseAreaDto({
    required this.nameAr,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
  });
  
  factory BrowseAreaDto.fromJson(Map<String, Object?> json) => _$BrowseAreaDtoFromJson(json);
  
  final String nameAr;
  final String nameEn;

  /// The circle's center.
  final num latitude;
  final num longitude;
  final num radiusKm;

  Map<String, Object?> toJson() => _$BrowseAreaDtoToJson(this);
}
