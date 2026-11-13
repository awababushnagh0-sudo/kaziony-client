// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCustomerDto _$AdminCustomerDtoFromJson(Map<String, dynamic> json) =>
    AdminCustomerDto(
      standing: CustomerStanding.fromJson(json['standing'] as String),
      id: json['id'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      contactPhone: json['contactPhone'] as String?,
      pausedUntil: json['pausedUntil'] == null
          ? null
          : DateTime.parse(json['pausedUntil'] as String),
      strikes: json['strikes'] as num,
      missedPickups: json['missedPickups'] as num,
      bookings: json['bookings'] as num,
      pickedUp: json['pickedUp'] as num,
      lastBookedAt: json['lastBookedAt'] == null
          ? null
          : DateTime.parse(json['lastBookedAt'] as String),
      lastLoginAt: json['lastLoginAt'] == null
          ? null
          : DateTime.parse(json['lastLoginAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AdminCustomerDtoToJson(AdminCustomerDto instance) =>
    <String, dynamic>{
      'standing': instance.standing,
      'id': instance.id,
      'name': ?instance.name,
      'email': ?instance.email,
      'contactPhone': ?instance.contactPhone,
      'pausedUntil': ?instance.pausedUntil?.toIso8601String(),
      'strikes': instance.strikes,
      'missedPickups': instance.missedPickups,
      'bookings': instance.bookings,
      'pickedUp': instance.pickedUp,
      'lastBookedAt': ?instance.lastBookedAt?.toIso8601String(),
      'lastLoginAt': ?instance.lastLoginAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };
