// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_strike_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCustomerStrikeDto _$AdminCustomerStrikeDtoFromJson(
  Map<String, dynamic> json,
) => AdminCustomerStrikeDto(
  id: json['id'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  counts: json['counts'] as bool,
  claim: json['claim'] == null
      ? null
      : AdminCustomerStrikeClaimDto.fromJson(
          json['claim'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AdminCustomerStrikeDtoToJson(
  AdminCustomerStrikeDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'createdAt': instance.createdAt.toIso8601String(),
  'counts': instance.counts,
  'claim': ?instance.claim,
};
