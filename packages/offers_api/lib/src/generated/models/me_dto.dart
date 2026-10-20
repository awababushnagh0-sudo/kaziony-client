// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'membership_dto.dart';
import 'user_role.dart';

part 'me_dto.g.dart';

@JsonSerializable()
class MeDto {
  const MeDto({
    required this.role,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.mustChangePassword,
    required this.contactPhone,
    required this.memberships,
  });
  
  factory MeDto.fromJson(Map<String, Object?> json) => _$MeDtoFromJson(json);
  
  final UserRole role;
  final String id;
  final String? name;
  final String? email;
  final String? phone;
  final String? avatarUrl;

  /// True for merchants who still have the temporary password from onboarding.
  final bool mustChangePassword;
  final String? contactPhone;

  /// Stores this user works at (merchants only).
  final List<MembershipDto> memberships;

  Map<String, Object?> toJson() => _$MeDtoToJson(this);
}
