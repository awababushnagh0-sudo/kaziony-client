// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'notification_booking_dto.dart';
import 'notification_kind.dart';

part 'notification_dto.g.dart';

@JsonSerializable()
class NotificationDto {
  const NotificationDto({
    required this.kind,
    required this.id,
    required this.booking,
    required this.read,
    required this.createdAt,
  });
  
  factory NotificationDto.fromJson(Map<String, Object?> json) => _$NotificationDtoFromJson(json);
  
  /// What it says; the app words it. One this version of the app doesn't.
  /// know can be left out.
  final NotificationKind kind;
  final String id;

  /// The booking it's about (BOOKING_CANCELLED).
  final NotificationBookingDto? booking;

  /// Seen in the inbox already.
  final bool read;
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$NotificationDtoToJson(this);
}
