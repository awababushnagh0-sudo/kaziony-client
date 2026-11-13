// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_booking_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCustomerBookingOfferDto _$AdminCustomerBookingOfferDtoFromJson(
  Map<String, dynamic> json,
) => AdminCustomerBookingOfferDto(
  type: OfferType.fromJson(json['type'] as String),
  id: json['id'] as String,
  title: json['title'] as String,
);

Map<String, dynamic> _$AdminCustomerBookingOfferDtoToJson(
  AdminCustomerBookingOfferDto instance,
) => <String, dynamic>{
  'type': instance.type,
  'id': instance.id,
  'title': instance.title,
};
