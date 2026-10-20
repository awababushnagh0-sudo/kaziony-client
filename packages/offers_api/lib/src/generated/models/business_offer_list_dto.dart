// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'business_offer_dto.dart';
import 'page_meta_dto.dart';

part 'business_offer_list_dto.g.dart';

@JsonSerializable()
class BusinessOfferListDto {
  const BusinessOfferListDto({
    required this.items,
    required this.meta,
  });
  
  factory BusinessOfferListDto.fromJson(Map<String, Object?> json) => _$BusinessOfferListDtoFromJson(json);
  
  final List<BusinessOfferDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$BusinessOfferListDtoToJson(this);
}
