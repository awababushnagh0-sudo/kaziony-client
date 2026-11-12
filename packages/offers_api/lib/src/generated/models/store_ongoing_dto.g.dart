// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_ongoing_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreOngoingDto _$StoreOngoingDtoFromJson(Map<String, dynamic> json) =>
    StoreOngoingDto(
      liveOffers: json['liveOffers'] as num,
      openBookings: json['openBookings'] as num,
      outForDelivery: json['outForDelivery'] as num,
    );

Map<String, dynamic> _$StoreOngoingDtoToJson(StoreOngoingDto instance) =>
    <String, dynamic>{
      'liveOffers': instance.liveOffers,
      'openBookings': instance.openBookings,
      'outForDelivery': instance.outForDelivery,
    };
