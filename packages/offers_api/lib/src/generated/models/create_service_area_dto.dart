// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_service_area_dto.g.dart';

@JsonSerializable()
class CreateServiceAreaDto {
  const CreateServiceAreaDto({
    required this.nameAr,
    required this.nameEn,
    required this.latitude,
    required this.longitude,
    required this.radiusKm,
    this.isActive,
  });
  
  factory CreateServiceAreaDto.fromJson(Map<String, Object?> json) => _$CreateServiceAreaDtoFromJson(json);
  
  final String nameAr;
  final String nameEn;
  final num latitude;
  final num longitude;
  final num radiusKm;

  /// Defaults to on.
  final bool? isActive;

  Map<String, Object?> toJson() => _$CreateServiceAreaDtoToJson(this);
}
