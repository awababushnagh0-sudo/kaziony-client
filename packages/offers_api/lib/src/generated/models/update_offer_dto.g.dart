// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_offer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateOfferDto _$UpdateOfferDtoFromJson(Map<String, dynamic> json) =>
    UpdateOfferDto(
      title: json['title'] as String?,
      description: json['description'] as String?,
      endsAt: json['endsAt'] == null
          ? null
          : DateTime.parse(json['endsAt'] as String),
    );

Map<String, dynamic> _$UpdateOfferDtoToJson(UpdateOfferDto instance) =>
    <String, dynamic>{
      'title': ?instance.title,
      'description': ?instance.description,
      'endsAt': ?instance.endsAt?.toIso8601String(),
    };
