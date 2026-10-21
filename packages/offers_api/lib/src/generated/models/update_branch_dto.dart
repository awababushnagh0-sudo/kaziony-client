// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'city.dart';

part 'update_branch_dto.g.dart';

@JsonSerializable()
class UpdateBranchDto {
  const UpdateBranchDto({
    required this.city,
    required this.name,
    required this.area,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.openingHours,
    required this.isActive,
  });
  
  factory UpdateBranchDto.fromJson(Map<String, Object?> json) => _$UpdateBranchDtoFromJson(json);
  
  final City city;
  final String name;
  final String area;
  final String address;
  final num latitude;
  final num longitude;
  final String phone;

  /// Opening hours per day.
  final dynamic openingHours;
  final bool isActive;

  Map<String, Object?> toJson() => _$UpdateBranchDtoToJson(this);
}
