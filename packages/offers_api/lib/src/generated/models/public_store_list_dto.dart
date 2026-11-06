// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'page_meta_dto.dart';
import 'public_store_summary_dto.dart';

part 'public_store_list_dto.g.dart';

@JsonSerializable()
class PublicStoreListDto {
  const PublicStoreListDto({
    required this.items,
    required this.meta,
  });
  
  factory PublicStoreListDto.fromJson(Map<String, Object?> json) => _$PublicStoreListDtoFromJson(json);
  
  final List<PublicStoreSummaryDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$PublicStoreListDtoToJson(this);
}
