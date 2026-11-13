// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_customer_dto.dart';
import 'page_meta_dto.dart';

part 'admin_customer_list_dto.g.dart';

@JsonSerializable()
class AdminCustomerListDto {
  const AdminCustomerListDto({
    required this.items,
    required this.meta,
  });
  
  factory AdminCustomerListDto.fromJson(Map<String, Object?> json) => _$AdminCustomerListDtoFromJson(json);
  
  final List<AdminCustomerDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$AdminCustomerListDtoToJson(this);
}
