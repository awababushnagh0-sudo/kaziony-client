// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOfferDto _$CreateOfferDtoFromJson(Map<String, dynamic> json) =>
    CreateOfferDto(
      type: OfferType.fromJson(json['type'] as String),
      productId: json['productId'] as String,
      offerPrice: json['offerPrice'] as String,
      endsAt: DateTime.parse(json['endsAt'] as String),
      totalQuantity: json['totalQuantity'] as num?,
      maxPerUser: json['maxPerUser'] as num?,
      claimWindowMinutes: json['claimWindowMinutes'] as num?,
      startsAt: json['startsAt'] == null
          ? null
          : DateTime.parse(json['startsAt'] as String),
      branchIds: (json['branchIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      title: json['title'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateOfferDtoToJson(CreateOfferDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'productId': instance.productId,
      'offerPrice': instance.offerPrice,
      'totalQuantity': instance.totalQuantity,
      'maxPerUser': instance.maxPerUser,
      'claimWindowMinutes': instance.claimWindowMinutes,
      'startsAt': instance.startsAt?.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'branchIds': instance.branchIds,
      'title': instance.title,
      'description': instance.description,
    };
