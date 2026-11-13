// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_claim_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerClaimDto _$PartnerClaimDtoFromJson(Map<String, dynamic> json) =>
    PartnerClaimDto(
      status: ClaimStatus.fromJson(json['status'] as String),
      cancelReason: json['cancelReason'] == null
          ? null
          : CancelReason.fromJson(json['cancelReason'] as String),
      id: json['id'] as String,
      code: json['code'] as String,
      quantity: json['quantity'] as num,
      totalPrice: json['totalPrice'] as String,
      customerName: json['customerName'] as String?,
      offer: ClaimOfferDto.fromJson(json['offer'] as Map<String, dynamic>),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      redeemedAt: json['redeemedAt'] == null
          ? null
          : DateTime.parse(json['redeemedAt'] as String),
      sentForDeliveryAt: json['sentForDeliveryAt'] == null
          ? null
          : DateTime.parse(json['sentForDeliveryAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      canRedeem: json['canRedeem'] as bool,
      canSendForDelivery: json['canSendForDelivery'] as bool,
      problem: json['problem'] as String?,
      problemCode: json['problemCode'] as String?,
    );

Map<String, dynamic> _$PartnerClaimDtoToJson(PartnerClaimDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'cancelReason': ?instance.cancelReason,
      'id': instance.id,
      'code': instance.code,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
      'customerName': ?instance.customerName,
      'offer': instance.offer,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'redeemedAt': ?instance.redeemedAt?.toIso8601String(),
      'sentForDeliveryAt': ?instance.sentForDeliveryAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'canRedeem': instance.canRedeem,
      'canSendForDelivery': instance.canSendForDelivery,
      'problem': ?instance.problem,
      'problemCode': ?instance.problemCode,
    };
