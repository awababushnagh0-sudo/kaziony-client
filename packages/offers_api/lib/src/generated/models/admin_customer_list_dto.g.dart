// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCustomerListDto _$AdminCustomerListDtoFromJson(
  Map<String, dynamic> json,
) => AdminCustomerListDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => AdminCustomerDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AdminCustomerListDtoToJson(
  AdminCustomerListDto instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};
