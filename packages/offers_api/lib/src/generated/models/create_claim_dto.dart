// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import, invalid_annotation_target, unnecessary_import

import 'package:json_annotation/json_annotation.dart';

part 'create_claim_dto.g.dart';

@JsonSerializable()
class CreateClaimDto {
  const CreateClaimDto({
    this.quantity,
  });
  
  factory CreateClaimDto.fromJson(Map<String, Object?> json) => _$CreateClaimDtoFromJson(json);
  
  /// Pieces to take with one code. Defaults to 1.
  final num? quantity;

  Map<String, Object?> toJson() => _$CreateClaimDtoToJson(this);
}
