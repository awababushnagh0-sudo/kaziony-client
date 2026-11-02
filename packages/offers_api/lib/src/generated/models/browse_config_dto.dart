// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'browse_area_dto.dart';

part 'browse_config_dto.g.dart';

@JsonSerializable()
class BrowseConfigDto {
  const BrowseConfigDto({
    required this.radiusKm,
    required this.areas,
  });
  
  factory BrowseConfigDto.fromJson(Map<String, Object?> json) => _$BrowseConfigDtoFromJson(json);
  
  /// Customers see offers from branches this close to them, in km.
  final num radiusKm;

  /// Where Kaziony works: customers browse from a point inside one of.
  /// these, or `GET /offers` answers 400 `OutsideServiceArea`.
  final List<BrowseAreaDto> areas;

  Map<String, Object?> toJson() => _$BrowseConfigDtoToJson(this);
}
