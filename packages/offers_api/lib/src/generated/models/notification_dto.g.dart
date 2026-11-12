// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDto _$NotificationDtoFromJson(Map<String, dynamic> json) =>
    NotificationDto(
      kind: NotificationKind.fromJson(json['kind'] as String),
      id: json['id'] as String,
      booking: json['booking'] == null
          ? null
          : NotificationBookingDto.fromJson(
              json['booking'] as Map<String, dynamic>,
            ),
      read: json['read'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$NotificationDtoToJson(NotificationDto instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'id': instance.id,
      'booking': ?instance.booking,
      'read': instance.read,
      'createdAt': instance.createdAt.toIso8601String(),
    };
