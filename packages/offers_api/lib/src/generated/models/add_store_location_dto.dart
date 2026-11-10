// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'city.dart';

part 'add_store_location_dto.g.dart';

@JsonSerializable()
class AddStoreLocationDto {
  const AddStoreLocationDto({
    required this.city,
    required this.latitude,
    required this.longitude,
    this.phone,
    this.area,
    this.address,
    this.openingHours,
  });
  
  factory AddStoreLocationDto.fromJson(Map<String, Object?> json) => _$AddStoreLocationDtoFromJson(json);
  
  final City city;

  /// This place's phone, if not the brand's.
  final String? phone;

  /// The neighbourhood, shown with the store's name: it tells a brand's.
  /// places apart.
  final String? area;
  final String? address;
  final num latitude;
  final num longitude;

  /// Opening hours per day ("sat" to "fri"), up to 4 times a day. A close.
  /// earlier than the open is past midnight; a day left out isn't said.
  final dynamic openingHours;

  Map<String, Object?> toJson() => _$AddStoreLocationDtoToJson(this);
}
