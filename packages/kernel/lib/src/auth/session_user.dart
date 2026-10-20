import 'package:offers_api/auth.dart' as api;

enum AccountRole { customer, merchant, admin, unknown }

/// A store the logged-in merchant works at.
class StoreMembership {
  const StoreMembership({
    required this.storeId,
    required this.storeName,
    required this.storeLogoUrl,
    required this.isOwner,
    required this.branchId,
  });

  factory StoreMembership.fromJson(Map<String, Object?> json) =>
      StoreMembership(
        storeId: json['storeId']! as String,
        storeName: json['storeName']! as String,
        storeLogoUrl: json['storeLogoUrl'] as String?,
        isOwner: json['isOwner']! as bool,
        branchId: json['branchId'] as String?,
      );

  final String storeId;
  final String storeName;
  final String? storeLogoUrl;

  /// Owners manage the store; staff only redeem at the counter.
  final bool isOwner;

  /// Staff limited to one branch. Null means all branches.
  final String? branchId;

  Map<String, Object?> toJson() => {
    'storeId': storeId,
    'storeName': storeName,
    'storeLogoUrl': storeLogoUrl,
    'isOwner': isOwner,
    'branchId': branchId,
  };
}

/// The logged-in user. Cached on the device so the app opens without a
/// connection.
class SessionUser {
  const SessionUser({
    required this.id,
    required this.role,
    required this.name,
    required this.phone,
    required this.email,
    required this.contactPhone,
    required this.mustChangePassword,
    required this.memberships,
  });

  factory SessionUser.fromMe(api.MeDto me) => SessionUser(
    id: me.id,
    role: switch (me.role) {
      api.UserRole.customer => AccountRole.customer,
      api.UserRole.merchant => AccountRole.merchant,
      api.UserRole.admin => AccountRole.admin,
      api.UserRole.$unknown => AccountRole.unknown,
    },
    name: me.name,
    phone: me.phone,
    email: me.email,
    contactPhone: me.contactPhone,
    mustChangePassword: me.mustChangePassword,
    memberships: [
      for (final membership in me.memberships)
        StoreMembership(
          storeId: membership.store.id,
          storeName: membership.store.name,
          storeLogoUrl: membership.store.logoUrl,
          isOwner: membership.role == api.StoreMemberRole.owner,
          branchId: membership.branchId,
        ),
    ],
  );

  factory SessionUser.fromJson(Map<String, Object?> json) => SessionUser(
    id: json['id']! as String,
    role: AccountRole.values.byName(json['role']! as String),
    name: json['name'] as String?,
    phone: json['phone'] as String?,
    email: json['email'] as String?,
    contactPhone: json['contactPhone'] as String?,
    mustChangePassword: json['mustChangePassword']! as bool,
    memberships: [
      for (final item in json['memberships']! as List<Object?>)
        StoreMembership.fromJson(item! as Map<String, Object?>),
    ],
  );

  final String id;
  final AccountRole role;
  final String? name;
  final String? phone;
  final String? email;
  final String? contactPhone;
  final bool mustChangePassword;
  final List<StoreMembership> memberships;

  Map<String, Object?> toJson() => {
    'id': id,
    'role': role.name,
    'name': name,
    'phone': phone,
    'email': email,
    'contactPhone': contactPhone,
    'mustChangePassword': mustChangePassword,
    'memberships': [for (final m in memberships) m.toJson()],
  };
}
