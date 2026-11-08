// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'saved_place_dto.g.dart';

@JsonSerializable()
class SavedPlaceDto {
  const SavedPlaceDto({
    required this.id,
    required this.name,
    required this.note,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
  });
  
  factory SavedPlaceDto.fromJson(Map<String, Object?> json) => _$SavedPlaceDtoFromJson(json);
  
  final String id;
  final String name;
  final String? note;
  final num latitude;
  final num longitude;
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$SavedPlaceDtoToJson(this);
}
