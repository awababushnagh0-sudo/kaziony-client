// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_store_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateStoreResponseDto _$CreateStoreResponseDtoFromJson(
  Map<String, dynamic> json,
) => CreateStoreResponseDto(
  store: StoreDetailDto.fromJson(json['store'] as Map<String, dynamic>),
  owner: NewAccountDto.fromJson(json['owner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateStoreResponseDtoToJson(
  CreateStoreResponseDto instance,
) => <String, dynamic>{'store': instance.store, 'owner': instance.owner};
