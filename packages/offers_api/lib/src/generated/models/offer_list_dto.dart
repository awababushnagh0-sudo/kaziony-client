// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_offer_dto.dart';
import 'page_meta_dto.dart';

part 'offer_list_dto.g.dart';

@JsonSerializable()
class OfferListDto {
  const OfferListDto({
    required this.items,
    required this.meta,
  });
  
  factory OfferListDto.fromJson(Map<String, Object?> json) => _$OfferListDtoFromJson(json);
  
  final List<AdminOfferDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$OfferListDtoToJson(this);
}
