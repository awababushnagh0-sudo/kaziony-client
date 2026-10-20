// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'membership_store_dto.dart';
import 'store_member_role.dart';

part 'membership_dto.g.dart';

@JsonSerializable()
class MembershipDto {
  const MembershipDto({
    required this.role,
    required this.branchId,
    required this.store,
  });
  
  factory MembershipDto.fromJson(Map<String, Object?> json) => _$MembershipDtoFromJson(json);
  
  final StoreMemberRole role;

  /// Null means the member works at all branches.
  final String? branchId;
  final MembershipStoreDto store;

  Map<String, Object?> toJson() => _$MembershipDtoToJson(this);
}
