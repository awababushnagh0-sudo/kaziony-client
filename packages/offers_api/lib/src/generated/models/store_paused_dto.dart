// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'store_paused_dto.g.dart';

@JsonSerializable()
class StorePausedDto {
  const StorePausedDto({
    required this.pausedUntil,
    required this.nextOpening,
    required this.waitingBookings,
    required this.cancelled,
  });
  
  factory StorePausedDto.fromJson(Map<String, Object?> json) => _$StorePausedDtoFromJson(json);
  
  /// Taking no bookings until then: customers see it closed. Null when not paused.
  final DateTime? pausedUntil;

  /// When the store next opens by its hours, once the stretch it's in now.
  /// has ended: what a pause without minutes runs to. Null when its hours.
  /// don't say.
  final DateTime? nextOpening;

  /// Bookings waiting to be picked up: what cancelling them would touch.
  final num waitingBookings;

  /// Bookings cancelled with the pause, their customers told.
  final num cancelled;

  Map<String, Object?> toJson() => _$StorePausedDtoToJson(this);
}
