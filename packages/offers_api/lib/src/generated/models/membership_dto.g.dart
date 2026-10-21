// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'membership_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MembershipDto _$MembershipDtoFromJson(Map<String, dynamic> json) =>
    MembershipDto(
      role: StoreMemberRole.fromJson(json['role'] as String),
      branchId: json['branchId'] as String?,
      store: MembershipStoreDto.fromJson(json['store'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MembershipDtoToJson(MembershipDto instance) =>
    <String, dynamic>{
      'role': instance.role,
      'branchId': ?instance.branchId,
      'store': instance.store,
    };
