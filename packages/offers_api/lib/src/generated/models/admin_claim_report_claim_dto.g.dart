// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_claim_report_claim_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminClaimReportClaimDto _$AdminClaimReportClaimDtoFromJson(
  Map<String, dynamic> json,
) => AdminClaimReportClaimDto(
  status: ClaimStatus.fromJson(json['status'] as String),
  cancelReason: json['cancelReason'] == null
      ? null
      : CancelReason.fromJson(json['cancelReason'] as String),
  offerType: OfferType.fromJson(json['offerType'] as String),
  id: json['id'] as String,
  code: json['code'] as String,
  quantity: json['quantity'] as num,
  totalPrice: json['totalPrice'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  redeemedAt: json['redeemedAt'] == null
      ? null
      : DateTime.parse(json['redeemedAt'] as String),
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  offerId: json['offerId'] as String,
  offerTitle: json['offerTitle'] as String,
);

Map<String, dynamic> _$AdminClaimReportClaimDtoToJson(
  AdminClaimReportClaimDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'cancelReason': ?instance.cancelReason,
  'offerType': instance.offerType,
  'id': instance.id,
  'code': instance.code,
  'quantity': instance.quantity,
  'totalPrice': instance.totalPrice,
  'createdAt': instance.createdAt.toIso8601String(),
  'expiresAt': instance.expiresAt.toIso8601String(),
  'redeemedAt': ?instance.redeemedAt?.toIso8601String(),
  'cancelledAt': ?instance.cancelledAt?.toIso8601String(),
  'offerId': instance.offerId,
  'offerTitle': instance.offerTitle,
};
