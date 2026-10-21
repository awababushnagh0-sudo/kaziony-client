// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminOfferDto _$AdminOfferDtoFromJson(Map<String, dynamic> json) =>
    AdminOfferDto(
      type: OfferType.fromJson(json['type'] as String),
      status: OfferStatus.fromJson(json['status'] as String),
      id: json['id'] as String,
      title: json['title'] as String,
      store: OfferStoreDto.fromJson(json['store'] as Map<String, dynamic>),
      originalPrice: json['originalPrice'] as String,
      offerPrice: json['offerPrice'] as String,
      totalQuantity: json['totalQuantity'] as num?,
      remainingQuantity: json['remainingQuantity'] as num?,
      claimCount: json['claimCount'] as num,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AdminOfferDtoToJson(AdminOfferDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'status': instance.status,
      'id': instance.id,
      'title': instance.title,
      'store': instance.store,
      'originalPrice': instance.originalPrice,
      'offerPrice': instance.offerPrice,
      'totalQuantity': ?instance.totalQuantity,
      'remainingQuantity': ?instance.remainingQuantity,
      'claimCount': instance.claimCount,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
