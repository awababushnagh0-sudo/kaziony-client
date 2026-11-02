// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_area_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceAreaDto _$ServiceAreaDtoFromJson(Map<String, dynamic> json) =>
    ServiceAreaDto(
      nameAr: json['nameAr'] as String,
      nameEn: json['nameEn'] as String,
      latitude: json['latitude'] as num,
      longitude: json['longitude'] as num,
      radiusKm: json['radiusKm'] as num,
      id: json['id'] as String,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$ServiceAreaDtoToJson(ServiceAreaDto instance) =>
    <String, dynamic>{
      'nameAr': instance.nameAr,
      'nameEn': instance.nameEn,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radiusKm': instance.radiusKm,
      'id': instance.id,
      'isActive': instance.isActive,
    };
