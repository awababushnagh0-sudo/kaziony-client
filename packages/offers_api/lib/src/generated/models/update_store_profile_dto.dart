// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'update_store_profile_dto.g.dart';

@JsonSerializable()
class UpdateStoreProfileDto {
  const UpdateStoreProfileDto({
    this.description,
    this.phone,
    this.facebookUrl,
    this.instagramUrl,
  });
  
  factory UpdateStoreProfileDto.fromJson(Map<String, Object?> json) => _$UpdateStoreProfileDtoFromJson(json);
  
  final String? description;
  final String? phone;
  final String? facebookUrl;
  final String? instagramUrl;

  Map<String, Object?> toJson() => _$UpdateStoreProfileDtoToJson(this);
}
