// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_claim_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerClaimDto _$CustomerClaimDtoFromJson(
  Map<String, dynamic> json,
) => CustomerClaimDto(
  status: ClaimStatus.fromJson(json['status'] as String),
  cancelReason: json['cancelReason'] == null
      ? null
      : CancelReason.fromJson(json['cancelReason'] as String),
  id: json['id'] as String,
  code: json['code'] as String,
  quantity: json['quantity'] as num,
  totalPrice: json['totalPrice'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  redeemedAt: json['redeemedAt'] == null
      ? null
      : DateTime.parse(json['redeemedAt'] as String),
  sentForDeliveryAt: json['sentForDeliveryAt'] == null
      ? null
      : DateTime.parse(json['sentForDeliveryAt'] as String),
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  offer: CustomerClaimOfferDto.fromJson(json['offer'] as Map<String, dynamic>),
  store: CustomerClaimStoreDto.fromJson(json['store'] as Map<String, dynamic>),
  location: PublicLocationDto.fromJson(
    json['location'] as Map<String, dynamic>,
  ),
  canCancel: json['canCancel'] as bool,
  cancelEndsBooking: json['cancelEndsBooking'] as bool,
  myRating: json['myRating'] as num?,
  canRate: json['canRate'] as bool,
);

Map<String, dynamic> _$CustomerClaimDtoToJson(CustomerClaimDto instance) =>
    <String, dynamic>{
      'status': instance.status,
      'cancelReason': ?instance.cancelReason,
      'id': instance.id,
      'code': instance.code,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
      'expiresAt': instance.expiresAt.toIso8601String(),
      'redeemedAt': ?instance.redeemedAt?.toIso8601String(),
      'sentForDeliveryAt': ?instance.sentForDeliveryAt?.toIso8601String(),
      'cancelledAt': ?instance.cancelledAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'offer': instance.offer,
      'store': instance.store,
      'location': instance.location,
      'canCancel': instance.canCancel,
      'cancelEndsBooking': instance.cancelEndsBooking,
      'myRating': ?instance.myRating,
      'canRate': instance.canRate,
    };
