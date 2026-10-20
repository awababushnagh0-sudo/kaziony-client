// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'set_user_status_dto.g.dart';

@JsonSerializable()
class SetUserStatusDto {
  const SetUserStatusDto({
    required this.isActive,
  });
  
  factory SetUserStatusDto.fromJson(Map<String, Object?> json) => _$SetUserStatusDtoFromJson(json);
  
  /// False disables the account and logs it out everywhere.
  final bool isActive;

  Map<String, Object?> toJson() => _$SetUserStatusDtoToJson(this);
}
