// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_branch_dto.g.dart';

@JsonSerializable()
class CreateBranchDto {
  const CreateBranchDto({
    required this.name,
    required this.city,
    required this.latitude,
    required this.longitude,
    this.area,
    this.address,
    this.phone,
    this.openingHours,
  });
  
  factory CreateBranchDto.fromJson(Map<String, Object?> json) => _$CreateBranchDtoFromJson(json);
  
  final String name;
  final String city;
  final String? area;
  final String? address;
  final num latitude;
  final num longitude;
  final String? phone;

  /// Opening hours per day.
  final dynamic openingHours;

  Map<String, Object?> toJson() => _$CreateBranchDtoToJson(this);
}
