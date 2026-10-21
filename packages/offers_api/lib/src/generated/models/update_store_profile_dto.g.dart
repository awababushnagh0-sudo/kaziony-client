// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_store_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateStoreProfileDto _$UpdateStoreProfileDtoFromJson(
  Map<String, dynamic> json,
) => UpdateStoreProfileDto(
  description: json['description'] as String?,
  phone: json['phone'] as String?,
  facebookUrl: json['facebookUrl'] as String?,
  instagramUrl: json['instagramUrl'] as String?,
);

Map<String, dynamic> _$UpdateStoreProfileDtoToJson(
  UpdateStoreProfileDto instance,
) => <String, dynamic>{
  'description': ?instance.description,
  'phone': ?instance.phone,
  'facebookUrl': ?instance.facebookUrl,
  'instagramUrl': ?instance.instagramUrl,
};
