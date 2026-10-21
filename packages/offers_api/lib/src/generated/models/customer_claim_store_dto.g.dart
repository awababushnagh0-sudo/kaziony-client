// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_claim_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerClaimStoreDto _$CustomerClaimStoreDtoFromJson(
  Map<String, dynamic> json,
) => CustomerClaimStoreDto(
  id: json['id'] as String,
  name: json['name'] as String,
  logoUrl: json['logoUrl'] as String?,
);

Map<String, dynamic> _$CustomerClaimStoreDtoToJson(
  CustomerClaimStoreDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logoUrl': ?instance.logoUrl,
};
