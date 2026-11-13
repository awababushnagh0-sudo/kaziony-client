// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'category_dto.dart';
import 'city.dart';
import 'go_live_item.dart';
import 'store_member_dto.dart';

part 'store_detail_dto.g.dart';

@JsonSerializable()
class StoreDetailDto {
  const StoreDetailDto({
    required this.city,
    required this.openingHours,
    required this.specialHours,
    required this.missingToGoLive,
    required this.id,
    required this.name,
    required this.area,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pausedUntil,
    required this.logoUrl,
    required this.coverUrl,
    required this.phone,
    required this.email,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.pickupInstructions,
    required this.delivers,
    required this.deliveryPhone,
    required this.ratingAverage,
    required this.ratingCount,
    required this.isActive,
    required this.wasLive,
    required this.createdAt,
    required this.category,
    required this.members,
  });
  
  factory StoreDetailDto.fromJson(Map<String, Object?> json) => _$StoreDetailDtoFromJson(json);
  
  final City city;
  final dynamic openingHours;

  /// Dates that differ from openingHours (Ramadan, Eid, a holiday), those.
  /// that haven't ended: `[{ from, to, shifts }]`, no shifts for closed.
  final List<dynamic> specialHours;

  /// What the store still needs before it can be turned on, in this order.
  /// (none when it's ready). A live store can't lose them either.
  final List<GoLiveItem> missingToGoLive;
  final String id;
  final String name;

  /// The neighbourhood, shown with the name.
  final String area;
  final String? address;
  final num latitude;
  final num longitude;

  /// Offline (taking no bookings) until then; null when it isn't.
  final DateTime? pausedUntil;
  final String? logoUrl;
  final String? coverUrl;
  final String phone;
  final String? email;
  final String? facebookUrl;
  final String? instagramUrl;

  /// Shown to customers on every offer's page.
  final String? pickupInstructions;

  /// Has its own drivers: customers with a booking call to have it brought.
  final bool delivers;

  /// The drivers' number, if not [phone].
  final String? deliveryPhone;

  /// Average stars from customers' pickups, one decimal; null before the first.
  final num? ratingAverage;
  final num ratingCount;

  /// Seen by customers. New stores start off; see [missingToGoLive].
  final bool isActive;

  /// Has been on for customers: one that's off now was turned off, rather.
  /// than waiting for its first day.
  final bool wasLive;
  final DateTime createdAt;
  final CategoryDto category;
  final List<StoreMemberDto> members;

  Map<String, Object?> toJson() => _$StoreDetailDtoToJson(this);
}
