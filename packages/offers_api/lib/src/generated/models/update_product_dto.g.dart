// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_product_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateProductDto _$UpdateProductDtoFromJson(Map<String, dynamic> json) =>
    UpdateProductDto(
      title: json['title'] as String?,
      description: json['description'] as String?,
      regularPrice: json['regularPrice'] as String?,
      isArchived: json['isArchived'] as bool?,
    );

Map<String, dynamic> _$UpdateProductDtoToJson(UpdateProductDto instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'regularPrice': instance.regularPrice,
      'isArchived': instance.isArchived,
    };
