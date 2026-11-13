// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_customer_booking_offer_dto.dart';
import 'admin_customer_booking_store_dto.dart';
import 'cancel_reason.dart';
import 'claim_status.dart';

part 'admin_customer_booking_dto.g.dart';

@JsonSerializable()
class AdminCustomerBookingDto {
  const AdminCustomerBookingDto({
    required this.status,
    required this.cancelReason,
    required this.id,
    required this.code,
    required this.quantity,
    required this.totalPrice,
    required this.offer,
    required this.store,
    required this.createdAt,
    required this.expiresAt,
    required this.redeemedAt,
    required this.sentForDeliveryAt,
    required this.cancelledAt,
    required this.hasStrike,
    required this.reportId,
  });
  
  factory AdminCustomerBookingDto.fromJson(Map<String, Object?> json) => _$AdminCustomerBookingDtoFromJson(json);
  
  /// EXPIRED as soon as expiresAt passes, even before the cleanup job runs.
  /// OUT_FOR_DELIVERY has no time limit: the store closes it.
  final ClaimStatus status;

  /// Who cancelled it, when CANCELLED: anything but CUSTOMER wasn't the.
  /// customer's doing, and doesn't count against them.
  final CancelReason? cancelReason;
  final String id;
  final String code;
  final num quantity;

  /// LD with 3 decimals, e.g. "8.000"
  final String totalPrice;
  final AdminCustomerBookingOfferDto offer;
  final AdminCustomerBookingStoreDto store;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? redeemedAt;
  final DateTime? sentForDeliveryAt;
  final DateTime? cancelledAt;

  /// Missing it gave a strike (still standing).
  final bool hasStrike;

  /// Their report about it, if they made one.
  final String? reportId;

  Map<String, Object?> toJson() => _$AdminCustomerBookingDtoToJson(this);
}
