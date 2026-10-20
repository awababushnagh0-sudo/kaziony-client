// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_profile_dto.g.dart';

@JsonSerializable()
class UpdateProfileDto {
  const UpdateProfileDto({
    this.name,
    this.contactPhone,
  });
  
  factory UpdateProfileDto.fromJson(Map<String, Object?> json) => _$UpdateProfileDtoFromJson(json);
  
  final String? name;

  /// Phone the store can call about a pickup (not verified).
  final String? contactPhone;

  Map<String, Object?> toJson() => _$UpdateProfileDtoToJson(this);
}
