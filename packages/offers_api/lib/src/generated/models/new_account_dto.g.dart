// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewAccountDto _$NewAccountDtoFromJson(Map<String, dynamic> json) =>
    NewAccountDto(
      userId: json['userId'] as String,
      phone: json['phone'] as String,
      temporaryPassword: json['temporaryPassword'] as String?,
    );

Map<String, dynamic> _$NewAccountDtoToJson(NewAccountDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'phone': instance.phone,
      'temporaryPassword': instance.temporaryPassword,
    };
