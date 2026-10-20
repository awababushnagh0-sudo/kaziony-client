// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateProductDto _$CreateProductDtoFromJson(Map<String, dynamic> json) =>
    CreateProductDto(
      title: json['title'] as String,
      regularPrice: json['regularPrice'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateProductDtoToJson(CreateProductDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'regularPrice': instance.regularPrice,
    };
