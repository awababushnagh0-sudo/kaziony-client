// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_paused_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorePausedDto _$StorePausedDtoFromJson(Map<String, dynamic> json) =>
    StorePausedDto(
      pausedUntil: json['pausedUntil'] == null
          ? null
          : DateTime.parse(json['pausedUntil'] as String),
      nextOpening: json['nextOpening'] == null
          ? null
          : DateTime.parse(json['nextOpening'] as String),
      waitingBookings: json['waitingBookings'] as num,
      cancelled: json['cancelled'] as num,
    );

Map<String, dynamic> _$StorePausedDtoToJson(StorePausedDto instance) =>
    <String, dynamic>{
      'pausedUntil': ?instance.pausedUntil?.toIso8601String(),
      'nextOpening': ?instance.nextOpening?.toIso8601String(),
      'waitingBookings': instance.waitingBookings,
      'cancelled': instance.cancelled,
    };
