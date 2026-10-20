// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'new_merchant_dto.g.dart';

@JsonSerializable()
class NewMerchantDto {
  const NewMerchantDto({
    required this.name,
    required this.phone,
  });
  
  factory NewMerchantDto.fromJson(Map<String, Object?> json) => _$NewMerchantDtoFromJson(json);
  
  final String name;

  /// Their login. If a merchant with this phone exists, they're linked.
  /// instead of creating a new account.
  final String phone;

  Map<String, Object?> toJson() => _$NewMerchantDtoToJson(this);
}
