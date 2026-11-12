// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'unread_notifications_dto.g.dart';

@JsonSerializable()
class UnreadNotificationsDto {
  const UnreadNotificationsDto({
    required this.count,
  });
  
  factory UnreadNotificationsDto.fromJson(Map<String, Object?> json) => _$UnreadNotificationsDtoFromJson(json);
  
  /// For a dot on the bell.
  final num count;

  Map<String, Object?> toJson() => _$UnreadNotificationsDtoToJson(this);
}
