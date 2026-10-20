// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'claim_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClaimOfferDto _$ClaimOfferDtoFromJson(Map<String, dynamic> json) =>
    ClaimOfferDto(
      id: json['id'] as String,
      title: json['title'] as String,
      offerPrice: json['offerPrice'] as String,
      originalPrice: json['originalPrice'] as String,
      thumbUrl: json['thumbUrl'] as String?,
    );

Map<String, dynamic> _$ClaimOfferDtoToJson(ClaimOfferDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'offerPrice': instance.offerPrice,
      'originalPrice': instance.originalPrice,
      'thumbUrl': instance.thumbUrl,
    };
