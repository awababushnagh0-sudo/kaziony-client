// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'admin_customer_booking_store_dto.g.dart';

@JsonSerializable()
class AdminCustomerBookingStoreDto {
  const AdminCustomerBookingStoreDto({
    required this.id,
    required this.name,
    required this.area,
  });
  
  factory AdminCustomerBookingStoreDto.fromJson(Map<String, Object?> json) => _$AdminCustomerBookingStoreDtoFromJson(json);
  
  final String id;
  final String name;

  /// A brand's places share the name: the area tells which.
  final String area;

  Map<String, Object?> toJson() => _$AdminCustomerBookingStoreDtoToJson(this);
}
