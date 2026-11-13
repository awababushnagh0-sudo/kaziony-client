// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_customer_booking_counts_dto.dart';
import 'admin_customer_strike_dto.dart';
import 'auth_provider.dart';
import 'customer_standing.dart';

part 'admin_customer_details_dto.g.dart';

@JsonSerializable()
class AdminCustomerDetailsDto {
  const AdminCustomerDetailsDto({
    required this.standing,
    required this.signsInWith,
    required this.lastPauseEndedAt,
    required this.strikesBeforePause,
    required this.strikeHistory,
    required this.bookingCounts,
    required this.openReports,
    required this.following,
    required this.ratings,
    required this.isActive,
    required this.deletedAt,
    required this.id,
    required this.name,
    required this.email,
    required this.contactPhone,
    required this.pausedUntil,
    required this.strikes,
    required this.missedPickups,
    required this.bookings,
    required this.pickedUp,
    required this.lastBookedAt,
    required this.lastLoginAt,
    required this.createdAt,
  });
  
  factory AdminCustomerDetailsDto.fromJson(Map<String, Object?> json) => _$AdminCustomerDetailsDtoFromJson(json);
  
  final CustomerStanding standing;
  final List<AuthProvider> signsInWith;

  /// When their last pause ended (or ends): later ones are longer.
  final DateTime? lastPauseEndedAt;

  /// Strikes that count before booking pauses.
  final num strikesBeforePause;

  /// Every strike, the latest first, with the booking that gave it.
  final List<AdminCustomerStrikeDto> strikeHistory;
  final AdminCustomerBookingCountsDto bookingCounts;

  /// Their reports waiting for our team.
  final num openReports;

  /// Stores they follow.
  final num following;

  /// Stores they rated.
  final num ratings;

  /// Disabled by our team, or deleted by themselves.
  final bool isActive;
  final DateTime? deletedAt;
  final String id;

  /// Null once they deleted their account.
  final String? name;

  /// From Google or Apple.
  final String? email;

  /// Unverified, given on their first booking.
  final String? contactPhone;

  /// Booking is paused until then.
  final DateTime? pausedUntil;

  /// Missed pickups that count toward a pause now.
  final num strikes;

  /// Missed pickups ever, those taken back aside.
  final num missedPickups;
  final num bookings;
  final num pickedUp;
  final DateTime? lastBookedAt;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$AdminCustomerDetailsDtoToJson(this);
}
