// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'page_meta_dto.g.dart';

@JsonSerializable()
class PageMetaDto {
  const PageMetaDto({
    required this.page,
    required this.pageSize,
    required this.total,
  });
  
  factory PageMetaDto.fromJson(Map<String, Object?> json) => _$PageMetaDtoFromJson(json);
  
  final num page;
  final num pageSize;
  final num total;

  Map<String, Object?> toJson() => _$PageMetaDtoToJson(this);
}
