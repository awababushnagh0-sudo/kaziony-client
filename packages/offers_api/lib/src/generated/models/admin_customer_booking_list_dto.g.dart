// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_booking_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCustomerBookingListDto _$AdminCustomerBookingListDtoFromJson(
  Map<String, dynamic> json,
) => AdminCustomerBookingListDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => AdminCustomerBookingDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdminCustomerBookingListDtoToJson(
  AdminCustomerBookingListDto instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};
