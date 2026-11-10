// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_connections_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemConnectionsDto _$SystemConnectionsDtoFromJson(
  Map<String, dynamic> json,
) => SystemConnectionsDto(
  total: json['total'] as num,
  active: json['active'] as num,
  idle: json['idle'] as num,
  idleInTransaction: json['idleInTransaction'] as num,
  waitingOnLocks: json['waitingOnLocks'] as num,
  max: json['max'] as num,
);

Map<String, dynamic> _$SystemConnectionsDtoToJson(
  SystemConnectionsDto instance,
) => <String, dynamic>{
  'total': instance.total,
  'active': instance.active,
  'idle': instance.idle,
  'idleInTransaction': instance.idleInTransaction,
  'waitingOnLocks': instance.waitingOnLocks,
  'max': instance.max,
};
