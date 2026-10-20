// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'business_claim_dto.dart';
import 'page_meta_dto.dart';

part 'business_claim_list_dto.g.dart';

@JsonSerializable()
class BusinessClaimListDto {
  const BusinessClaimListDto({
    required this.items,
    required this.meta,
  });
  
  factory BusinessClaimListDto.fromJson(Map<String, Object?> json) => _$BusinessClaimListDtoFromJson(json);
  
  final List<BusinessClaimDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$BusinessClaimListDtoToJson(this);
}
