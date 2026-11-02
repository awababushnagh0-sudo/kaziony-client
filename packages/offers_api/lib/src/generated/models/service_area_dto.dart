// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'service_area_dto.g.dart';

@JsonSerializable()
class ServiceAreaDto {
  const ServiceAreaDto({
    required this.nameAr,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    required this.id,
    required this.isActive,
  });
  
  factory ServiceAreaDto.fromJson(Map<String, Object?> json) => _$ServiceAreaDtoFromJson(json);
  
  final String nameAr;
  final String nameEn;

  /// The circle's center.
  final num latitude;
  final num longitude;
  final num radiusKm;
  final String id;

  /// Off: customers there can't browse until it's back on.
  final bool isActive;

  Map<String, Object?> toJson() => _$ServiceAreaDtoToJson(this);
}
