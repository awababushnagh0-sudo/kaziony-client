// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'store_member_role.dart';

part 'add_member_dto.g.dart';

@JsonSerializable()
class AddMemberDto {
  const AddMemberDto({
    required this.role,
    required this.name,
    required this.phone,
    this.branchId,
  });
  
  factory AddMemberDto.fromJson(Map<String, Object?> json) => _$AddMemberDtoFromJson(json);
  
  final StoreMemberRole role;

  /// Limit staff to one branch. Leave empty for all branches.
  final String? branchId;
  final String name;

  /// Their login. If a merchant with this phone exists, they're linked.
  /// instead of creating a new account.
  final String phone;

  Map<String, Object?> toJson() => _$AddMemberDtoToJson(this);
}
