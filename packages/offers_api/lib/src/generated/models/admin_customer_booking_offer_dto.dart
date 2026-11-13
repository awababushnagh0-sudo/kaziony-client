// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'offer_type.dart';

part 'admin_customer_booking_offer_dto.g.dart';

@JsonSerializable()
class AdminCustomerBookingOfferDto {
  const AdminCustomerBookingOfferDto({
    required this.type,
    required this.id,
    required this.title,
  });
  
  factory AdminCustomerBookingOfferDto.fromJson(Map<String, Object?> json) => _$AdminCustomerBookingOfferDtoFromJson(json);
  
  final OfferType type;
  final String id;
  final String title;

  Map<String, Object?> toJson() => _$AdminCustomerBookingOfferDtoToJson(this);
}
