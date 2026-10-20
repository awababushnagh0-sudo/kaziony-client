// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_member_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddMemberResponseDto _$AddMemberResponseDtoFromJson(
  Map<String, dynamic> json,
) => AddMemberResponseDto(
  member: StoreMemberDto.fromJson(json['member'] as Map<String, dynamic>),
  account: NewAccountDto.fromJson(json['account'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AddMemberResponseDtoToJson(
  AddMemberResponseDto instance,
) => <String, dynamic>{'member': instance.member, 'account': instance.account};
