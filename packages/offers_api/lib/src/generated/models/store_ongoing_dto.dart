// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'store_ongoing_dto.g.dart';

@JsonSerializable()
class StoreOngoingDto {
  const StoreOngoingDto({
    required this.liveOffers,
    required this.openBookings,
    required this.outForDelivery,
  });
  
  factory StoreOngoingDto.fromJson(Map<String, Object?> json) => _$StoreOngoingDtoFromJson(json);
  
  /// Offers on now or coming up (not paused or ended): customers stop.
  /// seeing them while the store is off.
  final num liveOffers;

  /// Bookings waiting to be picked up. They stay valid, and one missed while.
  /// the store is off gives the customer no strike, unless our team cancels.
  /// them (`POST /admin/stores/{id}/cancel-bookings`).
  final num openBookings;

  /// Bookings the store's drivers are bringing. Neither turning the store.
  /// off nor cancelling its bookings touches them: the store closes each as.
  /// delivered or not.
  final num outForDelivery;

  Map<String, Object?> toJson() => _$StoreOngoingDtoToJson(this);
}
