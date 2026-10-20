// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserListDto _$UserListDtoFromJson(Map<String, dynamic> json) => UserListDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => AdminUserDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: PageMetaDto.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserListDtoToJson(UserListDto instance) =>
    <String, dynamic>{'items': instance.items, 'meta': instance.meta};
