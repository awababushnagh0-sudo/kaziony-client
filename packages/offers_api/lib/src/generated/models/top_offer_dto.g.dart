// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'top_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopOfferDto _$TopOfferDtoFromJson(Map<String, dynamic> json) => TopOfferDto(
  offerId: json['offerId'] as String,
  title: json['title'] as String,
  views: json['views'] as num,
  claims: json['claims'] as num,
  redeemed: json['redeemed'] as num,
);

Map<String, dynamic> _$TopOfferDtoToJson(TopOfferDto instance) =>
    <String, dynamic>{
      'offerId': instance.offerId,
      'title': instance.title,
      'views': instance.views,
      'claims': instance.claims,
      'redeemed': instance.redeemed,
    };
