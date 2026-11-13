// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pause_store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PauseStoreDto _$PauseStoreDtoFromJson(Map<String, dynamic> json) =>
    PauseStoreDto(
      minutes: json['minutes'] as num?,
      cancelBookings: json['cancelBookings'] as bool?,
    );

Map<String, dynamic> _$PauseStoreDtoToJson(PauseStoreDto instance) =>
    <String, dynamic>{
      'minutes': ?instance.minutes,
      'cancelBookings': ?instance.cancelBookings,
    };
