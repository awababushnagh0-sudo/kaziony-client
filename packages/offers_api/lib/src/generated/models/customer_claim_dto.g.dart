// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_claim_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerClaimDto _$CustomerClaimDtoFromJson(
  Map<String, dynamic> json,
) => CustomerClaimDto(
  status: ClaimStatus.fromJson(json['status'] as String),
  id: json['id'] as String,
  code: json['code'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  redeemedAt: json['redeemedAt'] == null
      ? null
      : DateTime.parse(json['redeemedAt'] as String),
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  offer: CustomerClaimOfferDto.fromJson(json['offer'] as Map<String, dynamic>),
  store: CustomerClaimStoreDto.fromJson(json['store'] as Map<String, dynamic>),
  branches: (json['branches'] as List<dynamic>)
      .map((e) => PublicBranchDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  canCancel: json['canCancel'] as bool,
);

Map<String, dynamic> _$CustomerClaimDtoToJson(CustomerClaimDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'id': instance.id,
      'code': instance.code,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'redeemedAt': instance.redeemedAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'offer': instance.offer,
      'store': instance.store,
      'branches': instance.branches,
      'canCancel': instance.canCancel,
    };
