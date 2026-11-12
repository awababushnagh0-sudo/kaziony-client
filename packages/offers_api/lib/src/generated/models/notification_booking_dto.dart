// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'cancel_reason.dart';

part 'notification_booking_dto.g.dart';

@JsonSerializable()
class NotificationBookingDto {
  const NotificationBookingDto({
    required this.cancelReason,
    required this.id,
    required this.offerTitle,
    required this.storeName,
    required this.storeArea,
  });
  
  factory NotificationBookingDto.fromJson(Map<String, Object?> json) => _$NotificationBookingDtoFromJson(json);
  
  /// Why it was cancelled, for BOOKING_CANCELLED.
  final CancelReason? cancelReason;
  final String id;
  final String offerTitle;
  final String storeName;

  /// The neighbourhood, shown with the name.
  final String storeArea;

  Map<String, Object?> toJson() => _$NotificationBookingDtoToJson(this);
}
