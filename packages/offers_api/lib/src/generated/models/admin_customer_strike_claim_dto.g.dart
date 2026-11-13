// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_strike_claim_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCustomerStrikeClaimDto _$AdminCustomerStrikeClaimDtoFromJson(
  Map<String, dynamic> json,
) => AdminCustomerStrikeClaimDto(
  id: json['id'] as String,
  code: json['code'] as String,
  offerTitle: json['offerTitle'] as String,
  storeName: json['storeName'] as String,
  storeArea: json['storeArea'] as String,
);

Map<String, dynamic> _$AdminCustomerStrikeClaimDtoToJson(
  AdminCustomerStrikeClaimDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'offerTitle': instance.offerTitle,
  'storeName': instance.storeName,
  'storeArea': instance.storeArea,
};
