// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationListDto _$NotificationListDtoFromJson(Map<String, dynamic> json) =>
    NotificationListDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NotificationListDtoToJson(
  NotificationListDto instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};
