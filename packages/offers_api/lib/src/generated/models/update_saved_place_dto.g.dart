// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_saved_place_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateSavedPlaceDto _$UpdateSavedPlaceDtoFromJson(Map<String, dynamic> json) =>
    UpdateSavedPlaceDto(
      name: json['name'] as String?,
      note: json['note'] as String?,
      latitude: json['latitude'] as num?,
      longitude: json['longitude'] as num?,
    );

Map<String, dynamic> _$UpdateSavedPlaceDtoToJson(
  UpdateSavedPlaceDto instance,
) => <String, dynamic>{
  'name': ?instance.name,
  'note': ?instance.note,
  'latitude': ?instance.latitude,
  'longitude': ?instance.longitude,
};
