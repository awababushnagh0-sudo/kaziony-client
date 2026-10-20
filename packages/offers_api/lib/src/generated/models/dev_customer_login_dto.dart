// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'dev_customer_login_dto.g.dart';

@JsonSerializable()
class DevCustomerLoginDto {
  const DevCustomerLoginDto({
    this.name,
  });
  
  factory DevCustomerLoginDto.fromJson(Map<String, Object?> json) => _$DevCustomerLoginDtoFromJson(json);
  
  /// Any name; the same name always logs into the same test customer.
  final String? name;

  Map<String, Object?> toJson() => _$DevCustomerLoginDtoToJson(this);
}
