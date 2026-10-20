// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipStoreDto _$MembershipStoreDtoFromJson(Map<String, dynamic> json) =>
    MembershipStoreDto(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
    );

Map<String, dynamic> _$MembershipStoreDtoToJson(MembershipStoreDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logoUrl': instance.logoUrl,
    };
