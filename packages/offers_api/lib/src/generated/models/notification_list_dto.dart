// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'notification_dto.dart';
import 'page_meta_dto.dart';

part 'notification_list_dto.g.dart';

@JsonSerializable()
class NotificationListDto {
  const NotificationListDto({
    required this.items,
    required this.meta,
  });
  
  factory NotificationListDto.fromJson(Map<String, Object?> json) => _$NotificationListDtoFromJson(json);
  
  final List<NotificationDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$NotificationListDtoToJson(this);
}
