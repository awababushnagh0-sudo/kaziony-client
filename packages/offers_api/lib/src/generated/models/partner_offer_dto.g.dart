// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerOfferDto _$PartnerOfferDtoFromJson(Map<String, dynamic> json) =>
    PartnerOfferDto(
      type: OfferType.fromJson(json['type'] as String),
      status: OfferStatus.fromJson(json['status'] as String),
      state: OfferState.fromJson(json['state'] as String),
      id: json['id'] as String,
      productId: json['productId'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      thumbUrl: json['thumbUrl'] as String?,
      originalPrice: json['originalPrice'] as String,
      offerPrice: json['offerPrice'] as String,
      discountPercent: json['discountPercent'] as num,
      totalQuantity: json['totalQuantity'] as num?,
      remainingQuantity: json['remainingQuantity'] as num?,
      maxPerUser: json['maxPerUser'] as num,
      claimWindowMinutes: json['claimWindowMinutes'] as num,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      branchIds: (json['branchIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      viewCount: json['viewCount'] as num,
      claims: ClaimCountsDto.fromJson(json['claims'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PartnerOfferDtoToJson(PartnerOfferDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'status': instance.status,
      'state': instance.state,
      'id': instance.id,
      'productId': instance.productId,
      'title': instance.title,
      'description': ?instance.description,
      'imageUrl': ?instance.imageUrl,
      'thumbUrl': ?instance.thumbUrl,
      'originalPrice': instance.originalPrice,
      'offerPrice': instance.offerPrice,
      'discountPercent': instance.discountPercent,
      'totalQuantity': ?instance.totalQuantity,
      'remainingQuantity': ?instance.remainingQuantity,
      'maxPerUser': instance.maxPerUser,
      'claimWindowMinutes': instance.claimWindowMinutes,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'branchIds': instance.branchIds,
      'viewCount': instance.viewCount,
      'claims': instance.claims,
      'createdAt': instance.createdAt.toIso8601String(),
    };
