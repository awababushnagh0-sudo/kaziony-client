// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_status_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingStatusDto _$BookingStatusDtoFromJson(Map<String, dynamic> json) =>
    BookingStatusDto(
      strikes: json['strikes'] as num,
      strikesBeforePause: json['strikesBeforePause'] as num,
      strikeDays: json['strikeDays'] as num,
      strikeFadesAt: json['strikeFadesAt'] == null
          ? null
          : DateTime.parse(json['strikeFadesAt'] as String),
      lastStrikeAt: json['lastStrikeAt'] == null
          ? null
          : DateTime.parse(json['lastStrikeAt'] as String),
      pausedUntil: json['pausedUntil'] == null
          ? null
          : DateTime.parse(json['pausedUntil'] as String),
      nextPauseDays: json['nextPauseDays'] as num,
      activeReservations: json['activeReservations'] as num,
      maxActiveReservations: json['maxActiveReservations'] as num,
      holdMinutes: json['holdMinutes'] as num,
    );

Map<String, dynamic> _$BookingStatusDtoToJson(BookingStatusDto instance) =>
    <String, dynamic>{
      'strikes': instance.strikes,
      'strikesBeforePause': instance.strikesBeforePause,
      'strikeDays': instance.strikeDays,
      'strikeFadesAt': ?instance.strikeFadesAt?.toIso8601String(),
      'lastStrikeAt': ?instance.lastStrikeAt?.toIso8601String(),
      'pausedUntil': ?instance.pausedUntil?.toIso8601String(),
      'nextPauseDays': instance.nextPauseDays,
      'activeReservations': instance.activeReservations,
      'maxActiveReservations': instance.maxActiveReservations,
      'holdMinutes': instance.holdMinutes,
    };
