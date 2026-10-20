// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'admin_user_dto.dart';
import 'page_meta_dto.dart';

part 'user_list_dto.g.dart';

@JsonSerializable()
class UserListDto {
  const UserListDto({
    required this.items,
    required this.meta,
  });
  
  factory UserListDto.fromJson(Map<String, Object?> json) => _$UserListDtoFromJson(json);
  
  final List<AdminUserDto> items;
  final PageMetaDto meta;

  Map<String, Object?> toJson() => _$UserListDtoToJson(this);
}
