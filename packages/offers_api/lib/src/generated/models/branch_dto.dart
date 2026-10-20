// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'branch_dto.g.dart';

@JsonSerializable()
class BranchDto {
  const BranchDto({
    required this.openingHours,
    required this.id,
    required this.name,
    required this.city,
    required this.area,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.phone,
    required this.isActive,
  });
  
  factory BranchDto.fromJson(Map<String, Object?> json) => _$BranchDtoFromJson(json);
  
  final dynamic openingHours;
  final String id;
  final String name;
  final String city;
  final String? area;
  final String? address;
  final num latitude;
  final num longitude;
  final String? phone;
  final bool isActive;

  Map<String, Object?> toJson() => _$BranchDtoToJson(this);
}
