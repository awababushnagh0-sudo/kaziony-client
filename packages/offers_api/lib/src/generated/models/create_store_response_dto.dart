// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

import 'new_account_dto.dart';
import 'store_detail_dto.dart';

part 'create_store_response_dto.g.dart';

@JsonSerializable()
class CreateStoreResponseDto {
  const CreateStoreResponseDto({
    required this.store,
    required this.owner,
  });
  
  factory CreateStoreResponseDto.fromJson(Map<String, Object?> json) => _$CreateStoreResponseDtoFromJson(json);
  
  final StoreDetailDto store;
  final NewAccountDto owner;

  Map<String, Object?> toJson() => _$CreateStoreResponseDtoToJson(this);
}
