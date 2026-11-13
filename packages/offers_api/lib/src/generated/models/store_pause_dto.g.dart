// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_pause_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorePauseDto _$StorePauseDtoFromJson(Map<String, dynamic> json) =>
    StorePauseDto(
      pausedUntil: json['pausedUntil'] == null
          ? null
          : DateTime.parse(json['pausedUntil'] as String),
      nextOpening: json['nextOpening'] == null
          ? null
          : DateTime.parse(json['nextOpening'] as String),
      waitingBookings: json['waitingBookings'] as num,
    );

Map<String, dynamic> _$StorePauseDtoToJson(StorePauseDto instance) =>
    <String, dynamic>{
      'pausedUntil': ?instance.pausedUntil?.toIso8601String(),
      'nextOpening': ?instance.nextOpening?.toIso8601String(),
      'waitingBookings': instance.waitingBookings,
    };
