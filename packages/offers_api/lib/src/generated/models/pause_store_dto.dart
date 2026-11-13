// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'pause_store_dto.g.dart';

@JsonSerializable()
class PauseStoreDto {
  const PauseStoreDto({
    this.minutes,
    this.cancelBookings,
  });
  
  factory PauseStoreDto.fromJson(Map<String, Object?> json) => _$PauseStoreDtoFromJson(json);
  
  /// How long from now, 5 minutes to 12 hours: a break. Without it, until.
  /// the store next opens by its hours (the rest of the day, or until its.
  /// next shift).
  final num? minutes;

  /// The store has to close suddenly: cancel the bookings waiting to be.
  /// picked up too. The pieces go back on sale and each customer is told,.
  /// with no strike. Deliveries already on their way are left alone.
  final bool? cancelBookings;

  Map<String, Object?> toJson() => _$PauseStoreDtoToJson(this);
}
