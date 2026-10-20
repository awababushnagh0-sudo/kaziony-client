// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'new_account_dto.g.dart';

@JsonSerializable()
class NewAccountDto {
  const NewAccountDto({
    required this.userId,
    required this.phone,
    required this.temporaryPassword,
  });
  
  factory NewAccountDto.fromJson(Map<String, Object?> json) => _$NewAccountDtoFromJson(json);
  
  final String userId;
  final String phone;

  /// Shown only once. Null if the phone already had a merchant account,.
  /// which was linked instead.
  final String? temporaryPassword;

  Map<String, Object?> toJson() => _$NewAccountDtoToJson(this);
}
