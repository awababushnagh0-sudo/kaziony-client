// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'page_meta_dto.dart';
import 'partner_offer_dto.dart';

part 'partner_offer_list_dto.g.dart';

@JsonSerializable()
class PartnerOfferListDto {
  const PartnerOfferListDto({
    required this.items,
    required this.meta,
  });
  
  factory PartnerOfferListDto.fromJson(Map<String, Object?> json) => _$PartnerOfferListDtoFromJson(json);
  
  final List<PartnerOfferDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$PartnerOfferListDtoToJson(this);
}
