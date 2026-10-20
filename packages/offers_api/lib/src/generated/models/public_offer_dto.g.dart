// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicOfferDto _$PublicOfferDtoFromJson(Map<String, dynamic> json) =>
    PublicOfferDto(
      type: OfferType.fromJson(json['type'] as String),
      state: OfferState.fromJson(json['state'] as String),
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      thumbUrl: json['thumbUrl'] as String?,
      originalPrice: json['originalPrice'] as String,
      offerPrice: json['offerPrice'] as String,
      discountPercent: json['discountPercent'] as num,
      remainingQuantity: json['remainingQuantity'] as num?,
      claimWindowMinutes: json['claimWindowMinutes'] as num,
      startsAt: DateTime.parse(json['startsAt'] as String),
      endsAt: DateTime.parse(json['endsAt'] as String),
      store: OfferStoreSummaryDto.fromJson(
        json['store'] as Map<String, dynamic>,
      ),
      nearestBranch: PublicBranchDto.fromJson(
        json['nearestBranch'] as Map<String, dynamic>,
      ),
      branchCount: json['branchCount'] as num,
    );

Map<String, dynamic> _$PublicOfferDtoToJson(PublicOfferDto instance) =>
    <String, dynamic>{
      'type': instance.type,
      'state': instance.state,
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'thumbUrl': instance.thumbUrl,
      'originalPrice': instance.originalPrice,
      'offerPrice': instance.offerPrice,
      'discountPercent': instance.discountPercent,
      'remainingQuantity': instance.remainingQuantity,
      'claimWindowMinutes': instance.claimWindowMinutes,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'store': instance.store,
      'nearestBranch': instance.nearestBranch,
      'branchCount': instance.branchCount,
    };
