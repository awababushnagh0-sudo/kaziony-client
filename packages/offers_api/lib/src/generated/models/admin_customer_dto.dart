// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'customer_standing.dart';

part 'admin_customer_dto.g.dart';

@JsonSerializable()
class AdminCustomerDto {
  const AdminCustomerDto({
    required this.standing,
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
  
  factory AdminCustomerDto.fromJson(Map<String, Object?> json) => _$AdminCustomerDtoFromJson(json);
  
  final CustomerStanding standing;
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

  Map<String, Object?> toJson() => _$AdminCustomerDtoToJson(this);
}
