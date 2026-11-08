// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_term_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchTermDto _$SearchTermDtoFromJson(Map<String, dynamic> json) =>
    SearchTermDto(
      query: json['query'] as String,
      searchCount: json['searchCount'] as num,
      lastResultCount: json['lastResultCount'] as num,
      lastSearchedAt: DateTime.parse(json['lastSearchedAt'] as String),
    );

Map<String, dynamic> _$SearchTermDtoToJson(SearchTermDto instance) =>
    <String, dynamic>{
      'query': instance.query,
      'searchCount': instance.searchCount,
      'lastResultCount': instance.lastResultCount,
      'lastSearchedAt': instance.lastSearchedAt.toIso8601String(),
    };
