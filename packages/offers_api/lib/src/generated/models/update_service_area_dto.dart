// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_service_area_dto.g.dart';

@JsonSerializable()
class UpdateServiceAreaDto {
  const UpdateServiceAreaDto({
    this.nameAr,
    this.nameEn,
    this.latitude,
    this.longitude,
    this.radiusKm,
    this.isActive,
  });
  
  factory UpdateServiceAreaDto.fromJson(Map<String, Object?> json) => _$UpdateServiceAreaDtoFromJson(json);
  
  final String? nameAr;
  final String? nameEn;
  final num? latitude;
  final num? longitude;
  final num? radiusKm;

  /// Defaults to on.
  final bool? isActive;

  Map<String, Object?> toJson() => _$UpdateServiceAreaDtoToJson(this);
}
