// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'booking_status_dto.g.dart';

@JsonSerializable()
class BookingStatusDto {
  const BookingStatusDto({
    required this.strikes,
    required this.strikesBeforePause,
    required this.strikeDays,
    required this.strikeFadesAt,
    required this.lastStrikeAt,
    required this.pausedUntil,
    required this.nextPauseDays,
    required this.activeReservations,
    required this.maxActiveReservations,
    required this.holdMinutes,
  });
  
  factory BookingStatusDto.fromJson(Map<String, Object?> json) => _$BookingStatusDtoFromJson(json);
  
  /// Missed pickups that count now: those of the last `strikeDays` days,.
  /// since the last pause.
  final num strikes;

  /// Missed pickups that pause booking.
  final num strikesBeforePause;

  /// How long a missed pickup counts, in days.
  final num strikeDays;

  /// When the oldest strike that counts stops counting; null without one.
  final DateTime? strikeFadesAt;

  /// The latest missed pickup that counts, for the app to say so once.
  final DateTime? lastStrikeAt;

  /// Booking is paused until then; null when it isn't.
  final DateTime? pausedUntil;

  /// How long the next pause would be, in days.
  final num nextPauseDays;

  /// Reservations held now (limited offers).
  final num activeReservations;
  final num maxActiveReservations;

  /// How long a reservation is held, in minutes.
  final num holdMinutes;

  Map<String, Object?> toJson() => _$BookingStatusDtoToJson(this);
}
