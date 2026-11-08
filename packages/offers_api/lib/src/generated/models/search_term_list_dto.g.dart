// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_term_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchTermListDto _$SearchTermListDtoFromJson(Map<String, dynamic> json) =>
    SearchTermListDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => SearchTermDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SearchTermListDtoToJson(SearchTermListDto instance) =>
    <String, dynamic>{'items': instance.items, 'meta': instance.meta};
