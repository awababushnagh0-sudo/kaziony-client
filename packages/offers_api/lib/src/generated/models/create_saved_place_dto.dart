// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_saved_place_dto.g.dart';

@JsonSerializable()
class CreateSavedPlaceDto {
  const CreateSavedPlaceDto({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.note,
  });
  
  factory CreateSavedPlaceDto.fromJson(Map<String, Object?> json) => _$CreateSavedPlaceDtoFromJson(json);
  
  final String name;

  /// How to find it. An empty string clears it.
  final String? note;

  /// Must be inside a service area: 400 with error "OutsideServiceArea".
  final num latitude;
  final num longitude;

  Map<String, Object?> toJson() => _$CreateSavedPlaceDtoToJson(this);
}
