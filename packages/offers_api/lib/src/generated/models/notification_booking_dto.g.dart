// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationBookingDto _$NotificationBookingDtoFromJson(
  Map<String, dynamic> json,
) => NotificationBookingDto(
  cancelReason: json['cancelReason'] == null
      ? null
      : CancelReason.fromJson(json['cancelReason'] as String),
  id: json['id'] as String,
  offerTitle: json['offerTitle'] as String,
  storeName: json['storeName'] as String,
  storeArea: json['storeArea'] as String,
);

Map<String, dynamic> _$NotificationBookingDtoToJson(
  NotificationBookingDto instance,
) => <String, dynamic>{
  'cancelReason': ?instance.cancelReason,
  'id': instance.id,
  'offerTitle': instance.offerTitle,
  'storeName': instance.storeName,
  'storeArea': instance.storeArea,
};
