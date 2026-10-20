// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'store_member_role.dart';

part 'store_member_dto.g.dart';

@JsonSerializable()
class StoreMemberDto {
  const StoreMemberDto({
    required this.role,
    required this.userId,
    required this.name,
    required this.phone,
    required this.branchId,
    required this.isActive,
    required this.mustChangePassword,
  });
  
  factory StoreMemberDto.fromJson(Map<String, Object?> json) => _$StoreMemberDtoFromJson(json);
  
  final StoreMemberRole role;
  final String userId;
  final String? name;
  final String? phone;
  final String? branchId;

  /// False if the account has been disabled.
  final bool isActive;

  /// Still using the temporary password.
  final bool mustChangePassword;

  Map<String, Object?> toJson() => _$StoreMemberDtoToJson(this);
}
