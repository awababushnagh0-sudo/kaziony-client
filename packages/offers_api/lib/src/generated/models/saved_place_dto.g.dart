// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_place_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedPlaceDto _$SavedPlaceDtoFromJson(Map<String, dynamic> json) =>
    SavedPlaceDto(
      id: json['id'] as String,
      name: json['name'] as String,
      note: json['note'] as String?,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$SavedPlaceDtoToJson(SavedPlaceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'note': ?instance.note,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'createdAt': instance.createdAt.toIso8601String(),
    };
