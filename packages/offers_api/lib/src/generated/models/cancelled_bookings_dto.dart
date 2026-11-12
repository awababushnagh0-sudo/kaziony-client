// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'cancelled_bookings_dto.g.dart';

@JsonSerializable()
class CancelledBookingsDto {
  const CancelledBookingsDto({
    required this.cancelled,
  });
  
  factory CancelledBookingsDto.fromJson(Map<String, Object?> json) => _$CancelledBookingsDtoFromJson(json);
  
  /// Bookings cancelled; their customers were told why.
  final num cancelled;

  Map<String, Object?> toJson() => _$CancelledBookingsDtoToJson(this);
}
