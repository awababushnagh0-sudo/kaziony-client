// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCustomerDetailsDto _$AdminCustomerDetailsDtoFromJson(
  Map<String, dynamic> json,
) => AdminCustomerDetailsDto(
  standing: CustomerStanding.fromJson(json['standing'] as String),
  signsInWith: (json['signsInWith'] as List<dynamic>)
      .map((e) => AuthProvider.fromJson(e as String))
      .toList(),
  lastPauseEndedAt: json['lastPauseEndedAt'] == null
      ? null
      : DateTime.parse(json['lastPauseEndedAt'] as String),
  strikesBeforePause: json['strikesBeforePause'] as num,
  strikeHistory: (json['strikeHistory'] as List<dynamic>)
      .map((e) => AdminCustomerStrikeDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  bookingCounts: AdminCustomerBookingCountsDto.fromJson(
    json['bookingCounts'] as Map<String, dynamic>,
  ),
  openReports: json['openReports'] as num,
  following: json['following'] as num,
  ratings: json['ratings'] as num,
  isActive: json['isActive'] as bool,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
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

Map<String, dynamic> _$AdminCustomerDetailsDtoToJson(
  AdminCustomerDetailsDto instance,
) => <String, dynamic>{
  'standing': instance.standing,
  'signsInWith': instance.signsInWith,
  'lastPauseEndedAt': ?instance.lastPauseEndedAt?.toIso8601String(),
  'strikesBeforePause': instance.strikesBeforePause,
  'strikeHistory': instance.strikeHistory,
  'bookingCounts': instance.bookingCounts,
  'openReports': instance.openReports,
  'following': instance.following,
  'ratings': instance.ratings,
  'isActive': instance.isActive,
  'deletedAt': ?instance.deletedAt?.toIso8601String(),
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
