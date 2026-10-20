// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'page_meta_dto.dart';
import 'public_offer_dto.dart';

part 'public_offer_list_dto.g.dart';

@JsonSerializable()
class PublicOfferListDto {
  const PublicOfferListDto({
    required this.items,
    required this.meta,
  });
  
  factory PublicOfferListDto.fromJson(Map<String, Object?> json) => _$PublicOfferListDtoFromJson(json);
  
  final List<PublicOfferDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$PublicOfferListDtoToJson(this);
}
