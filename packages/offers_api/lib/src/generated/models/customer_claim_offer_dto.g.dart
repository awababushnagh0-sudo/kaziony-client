// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_claim_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerClaimOfferDto _$CustomerClaimOfferDtoFromJson(
  Map<String, dynamic> json,
) => CustomerClaimOfferDto(
  type: OfferType.fromJson(json['type'] as String),
  id: json['id'] as String,
  title: json['title'] as String,
  offerPrice: json['offerPrice'] as String,
  originalPrice: json['originalPrice'] as String,
  thumbUrl: json['thumbUrl'] as String?,
);

Map<String, dynamic> _$CustomerClaimOfferDtoToJson(
  CustomerClaimOfferDto instance,
) => <String, dynamic>{
  'type': instance.type,
  'id': instance.id,
  'title': instance.title,
  'offerPrice': instance.offerPrice,
  'originalPrice': instance.originalPrice,
  'thumbUrl': ?instance.thumbUrl,
};
