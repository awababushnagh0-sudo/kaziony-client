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
    required this.specialHours,
    required this.area,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.pausedUntil,
    required this.distanceKm,
  });
  
  factory PublicLocationDto.fromJson(Map<String, Object?> json) => _$PublicLocationDtoFromJson(json);
  
  final City city;
  final dynamic openingHours;

  /// Dates that differ from openingHours (Ramadan, Eid, a holiday), in.
  /// place of their weekdays: `[{ from, to, shifts }]`, Libya dates like.
  /// "2027-02-08", no shifts for closed. Those that haven't ended.
  final List<dynamic> specialHours;
  final String area;
  final String? address;
  final num latitude;
  final num longitude;
  final String phone;

  /// The store went offline for a while: closed, whatever its hours say,.
  /// until then. Null when it isn't.
  final DateTime? pausedUntil;

  /// Null when no location was sent.
  final num? distanceKm;

  Map<String, Object?> toJson() => _$PublicLocationDtoToJson(this);
}
