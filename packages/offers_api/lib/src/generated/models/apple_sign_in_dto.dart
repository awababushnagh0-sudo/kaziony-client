// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'apple_sign_in_dto.g.dart';

@JsonSerializable()
class AppleSignInDto {
  const AppleSignInDto({
    required this.idToken,
    this.name,
  });
  
  factory AppleSignInDto.fromJson(Map<String, Object?> json) => _$AppleSignInDtoFromJson(json);
  
  /// Identity token from Sign in with Apple on the device.
  final String idToken;

  /// Apple only gives the name on the very first sign-in, so the app sends it.
  final String? name;

  Map<String, Object?> toJson() => _$AppleSignInDtoToJson(this);
}
