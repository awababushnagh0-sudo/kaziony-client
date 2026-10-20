// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchDto _$BranchDtoFromJson(Map<String, dynamic> json) => BranchDto(
  openingHours: json['openingHours'],
  id: json['id'] as String,
  name: json['name'] as String,
  city: json['city'] as String,
  area: json['area'] as String?,
  address: json['address'] as String?,
  latitude: json['latitude'] as num,
  longitude: json['longitude'] as num,
  phone: json['phone'] as String?,
  isActive: json['isActive'] as bool,
);

Map<String, dynamic> _$BranchDtoToJson(BranchDto instance) => <String, dynamic>{
  'openingHours': instance.openingHours,
  'id': instance.id,
  'name': instance.name,
  'city': instance.city,
  'area': instance.area,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'phone': instance.phone,
  'isActive': instance.isActive,
};
