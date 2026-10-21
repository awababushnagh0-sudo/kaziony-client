// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'city.dart';

part 'public_branch_dto.g.dart';

@JsonSerializable()
class PublicBranchDto {
  const PublicBranchDto({
    required this.city,
    required this.openingHours,
    required this.id,
    required this.name,
    required this.area,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.distanceKm,
  });
  
  factory PublicBranchDto.fromJson(Map<String, Object?> json) => _$PublicBranchDtoFromJson(json);
  
  final City city;
  final dynamic openingHours;
  final String id;
  final String name;
  final String? area;
  final String? address;
  final num latitude;
  final num longitude;
  final String? phone;

  /// Null when no location was sent.
  final num? distanceKm;

  Map<String, Object?> toJson() => _$PublicBranchDtoToJson(this);
}
