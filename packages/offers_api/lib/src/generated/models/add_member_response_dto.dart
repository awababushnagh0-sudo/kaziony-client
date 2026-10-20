// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'new_account_dto.dart';
import 'store_member_dto.dart';

part 'add_member_response_dto.g.dart';

@JsonSerializable()
class AddMemberResponseDto {
  const AddMemberResponseDto({
    required this.member,
    required this.account,
  });
  
  factory AddMemberResponseDto.fromJson(Map<String, Object?> json) => _$AddMemberResponseDtoFromJson(json);
  
  final StoreMemberDto member;
  final NewAccountDto account;

  Map<String, Object?> toJson() => _$AddMemberResponseDtoToJson(this);
}
