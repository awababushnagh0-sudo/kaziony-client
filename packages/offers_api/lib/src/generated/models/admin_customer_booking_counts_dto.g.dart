// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_booking_counts_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCustomerBookingCountsDto _$AdminCustomerBookingCountsDtoFromJson(
  Map<String, dynamic> json,
) => AdminCustomerBookingCountsDto(
  reserved: json['reserved'] as num,
  outForDelivery: json['outForDelivery'] as num,
  redeemed: json['redeemed'] as num,
  expired: json['expired'] as num,
  cancelled: json['cancelled'] as num,
);

Map<String, dynamic> _$AdminCustomerBookingCountsDtoToJson(
  AdminCustomerBookingCountsDto instance,
) => <String, dynamic>{
  'reserved': instance.reserved,
  'outForDelivery': instance.outForDelivery,
  'redeemed': instance.redeemed,
  'expired': instance.expired,
  'cancelled': instance.cancelled,
};
