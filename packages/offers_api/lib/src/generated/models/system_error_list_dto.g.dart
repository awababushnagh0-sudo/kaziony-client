// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_error_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SystemErrorListDto _$SystemErrorListDtoFromJson(Map<String, dynamic> json) =>
    SystemErrorListDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => SystemErrorDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SystemErrorListDtoToJson(SystemErrorListDto instance) =>
    <String, dynamic>{'items': instance.items};
