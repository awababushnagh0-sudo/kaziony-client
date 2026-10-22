// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'partner_claim_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartnerClaimDto _$PartnerClaimDtoFromJson(Map<String, dynamic> json) =>
    PartnerClaimDto(
      status: ClaimStatus.fromJson(json['status'] as String),
      id: json['id'] as String,
      code: json['code'] as String,
      customerName: json['customerName'] as String?,
      offer: ClaimOfferDto.fromJson(json['offer'] as Map<String, dynamic>),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      redeemedAt: json['redeemedAt'] == null
          ? null
          : DateTime.parse(json['redeemedAt'] as String),
      redeemedBranchId: json['redeemedBranchId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      canRedeem: json['canRedeem'] as bool,
      problem: json['problem'] as String?,
    );

Map<String, dynamic> _$PartnerClaimDtoToJson(PartnerClaimDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'id': instance.id,
      'code': instance.code,
      'customerName': ?instance.customerName,
      'offer': instance.offer,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'redeemedAt': ?instance.redeemedAt?.toIso8601String(),
      'redeemedBranchId': ?instance.redeemedBranchId,
      'createdAt': instance.createdAt.toIso8601String(),
      'canRedeem': instance.canRedeem,
      'problem': ?instance.problem,
    };
