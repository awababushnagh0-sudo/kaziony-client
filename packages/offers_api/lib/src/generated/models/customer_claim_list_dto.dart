// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'customer_claim_dto.dart';
import 'page_meta_dto.dart';

part 'customer_claim_list_dto.g.dart';

@JsonSerializable()
class CustomerClaimListDto {
  const CustomerClaimListDto({
    required this.items,
    required this.meta,
  });
  
  factory CustomerClaimListDto.fromJson(Map<String, Object?> json) => _$CustomerClaimListDtoFromJson(json);
  
  final List<CustomerClaimDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$CustomerClaimListDtoToJson(this);
}
