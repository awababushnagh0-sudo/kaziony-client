// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'membership_store_dto.g.dart';

@JsonSerializable()
class MembershipStoreDto {
  const MembershipStoreDto({
    required this.id,
    required this.name,
    required this.logoUrl,
  });
  
  factory MembershipStoreDto.fromJson(Map<String, Object?> json) => _$MembershipStoreDtoFromJson(json);
  
  final String id;
  final String name;
  final String? logoUrl;

  Map<String, Object?> toJson() => _$MembershipStoreDtoToJson(this);
}
