// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'resolved_location_dto.g.dart';

@JsonSerializable()
class ResolvedLocationDto {
  const ResolvedLocationDto({
    required this.latitude,
    required this.longitude,
  });
  
  factory ResolvedLocationDto.fromJson(Map<String, Object?> json) => _$ResolvedLocationDtoFromJson(json);
  
  final num latitude;
  final num longitude;

  Map<String, Object?> toJson() => _$ResolvedLocationDtoToJson(this);
}
