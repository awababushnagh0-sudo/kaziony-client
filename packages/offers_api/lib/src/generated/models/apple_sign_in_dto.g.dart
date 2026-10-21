// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apple_sign_in_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppleSignInDto _$AppleSignInDtoFromJson(Map<String, dynamic> json) =>
    AppleSignInDto(
      idToken: json['idToken'] as String,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$AppleSignInDtoToJson(AppleSignInDto instance) =>
    <String, dynamic>{'idToken': instance.idToken, 'name': ?instance.name};
