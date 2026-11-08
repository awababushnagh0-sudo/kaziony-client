// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'search_term_dto.g.dart';

@JsonSerializable()
class SearchTermDto {
  const SearchTermDto({
    required this.query,
    required this.searchCount,
    required this.lastResultCount,
    required this.lastSearchedAt,
  });
  
  factory SearchTermDto.fromJson(Map<String, Object?> json) => _$SearchTermDtoFromJson(json);
  
  /// As the search reads it: normalized, without words that say nothing.
  final String query;
  final num searchCount;

  /// Offers found the last time, around where it was searched.
  final num lastResultCount;
  final DateTime lastSearchedAt;

  Map<String, Object?> toJson() => _$SearchTermDtoToJson(this);
}
