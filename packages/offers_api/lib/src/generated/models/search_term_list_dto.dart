// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'page_meta_dto.dart';
import 'search_term_dto.dart';

part 'search_term_list_dto.g.dart';

@JsonSerializable()
class SearchTermListDto {
  const SearchTermListDto({
    required this.items,
    required this.meta,
  });
  
  factory SearchTermListDto.fromJson(Map<String, Object?> json) => _$SearchTermListDtoFromJson(json);
  
  final List<SearchTermDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$SearchTermListDtoToJson(this);
}
