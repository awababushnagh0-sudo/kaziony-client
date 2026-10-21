// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'resolve_location_dto.g.dart';

@JsonSerializable()
class ResolveLocationDto {
  const ResolveLocationDto({
    required this.link,
  });
  
  factory ResolveLocationDto.fromJson(Map<String, Object?> json) => _$ResolveLocationDtoFromJson(json);
  
  /// A Google Maps link, full or short (maps.app.goo.gl), or plain.
  /// coordinates.
  final String link;

  Map<String, Object?> toJson() => _$ResolveLocationDtoToJson(this);
}
