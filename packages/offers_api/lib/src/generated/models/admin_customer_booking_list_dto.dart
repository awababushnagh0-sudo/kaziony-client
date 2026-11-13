// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_customer_booking_dto.dart';
import 'page_meta_dto.dart';

part 'admin_customer_booking_list_dto.g.dart';

@JsonSerializable()
class AdminCustomerBookingListDto {
  const AdminCustomerBookingListDto({
    required this.items,
    required this.meta,
  });
  
  factory AdminCustomerBookingListDto.fromJson(Map<String, Object?> json) => _$AdminCustomerBookingListDtoFromJson(json);
  
  final List<AdminCustomerBookingDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$AdminCustomerBookingListDtoToJson(this);
}
