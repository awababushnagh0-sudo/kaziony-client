// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCustomerBookingDto _$AdminCustomerBookingDtoFromJson(
  Map<String, dynamic> json,
) => AdminCustomerBookingDto(
  status: ClaimStatus.fromJson(json['status'] as String),
  cancelReason: json['cancelReason'] == null
      ? null
      : CancelReason.fromJson(json['cancelReason'] as String),
  id: json['id'] as String,
  code: json['code'] as String,
  quantity: json['quantity'] as num,
  totalPrice: json['totalPrice'] as String,
  offer: AdminCustomerBookingOfferDto.fromJson(
    json['offer'] as Map<String, dynamic>,
  ),
  store: AdminCustomerBookingStoreDto.fromJson(
    json['store'] as Map<String, dynamic>,
  ),
  createdAt: DateTime.parse(json['createdAt'] as String),
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
  hasStrike: json['hasStrike'] as bool,
  reportId: json['reportId'] as String?,
);

Map<String, dynamic> _$AdminCustomerBookingDtoToJson(
  AdminCustomerBookingDto instance,
) => <String, dynamic>{
  'status': instance.status,
  'cancelReason': ?instance.cancelReason,
  'id': instance.id,
  'code': instance.code,
  'quantity': instance.quantity,
  'totalPrice': instance.totalPrice,
  'offer': instance.offer,
  'store': instance.store,
  'createdAt': instance.createdAt.toIso8601String(),
  'expiresAt': instance.expiresAt.toIso8601String(),
  'redeemedAt': ?instance.redeemedAt?.toIso8601String(),
  'sentForDeliveryAt': ?instance.sentForDeliveryAt?.toIso8601String(),
  'cancelledAt': ?instance.cancelledAt?.toIso8601String(),
  'hasStrike': instance.hasStrike,
  'reportId': ?instance.reportId,
};
