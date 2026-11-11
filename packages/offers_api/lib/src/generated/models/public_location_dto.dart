// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'city.dart';

part 'public_location_dto.g.dart';

@JsonSerializable()
class PublicLocationDto {
  const PublicLocationDto({
    required this.city,
    required this.openingHours,
    required this.area,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.distanceKm,
  });
  
  factory PublicLocationDto.fromJson(Map<String, Object?> json) => _$PublicLocationDtoFromJson(json);
  
  final City city;
  final dynamic openingHours;
  final String area;
  final String? address;
  final num latitude;
  final num longitude;
  final String phone;

  /// Null when no location was sent.
  final num? distanceKm;

  Map<String, Object?> toJson() => _$PublicLocationDtoToJson(this);
}
