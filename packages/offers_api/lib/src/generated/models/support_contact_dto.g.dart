// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_contact_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportContactDto _$SupportContactDtoFromJson(Map<String, dynamic> json) =>
    SupportContactDto(
      phone: json['phone'] as String,
      whatsapp: json['whatsapp'] as String,
      email: json['email'] as String,
      hoursAr: json['hoursAr'] as String,
      hoursEn: json['hoursEn'] as String,
    );

Map<String, dynamic> _$SupportContactDtoToJson(SupportContactDto instance) =>
    <String, dynamic>{
      'phone': instance.phone,
      'whatsapp': instance.whatsapp,
      'email': instance.email,
      'hoursAr': instance.hoursAr,
      'hoursEn': instance.hoursEn,
    };
