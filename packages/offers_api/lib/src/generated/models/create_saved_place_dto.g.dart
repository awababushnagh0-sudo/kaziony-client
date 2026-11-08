// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_saved_place_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateSavedPlaceDto _$CreateSavedPlaceDtoFromJson(Map<String, dynamic> json) =>
    CreateSavedPlaceDto(
      name: json['name'] as String,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$CreateSavedPlaceDtoToJson(
  CreateSavedPlaceDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'note': ?instance.note,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
