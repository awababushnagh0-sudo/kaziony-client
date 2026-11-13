import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/customer.dart';

/// Their name; their email or phone without one, as after deleting their
/// account.
String customerName(AdminLocalizations s, Customer customer) =>
    customer.name ?? customerContact(customer) ?? s.customerDeletedAccount;

/// How to reach them: their email, or their phone without one.
String? customerContact(Customer customer) =>
    customer.email ??
    switch (customer.contactPhone) {
      final phone? => formatLibyanPhone(phone),
      null => null,
    };

/// Where they stand, as a badge: orange while their booking is paused.
SBadge customerStandingBadge(
  AdminLocalizations s,
  CustomerStanding standing,
) => switch (standing) {
  CustomerStanding.active => SBadge(s.customerActive, tone: BadgeTone.success),
  CustomerStanding.paused => SBadge(s.customerPaused, tone: BadgeTone.warning),
  CustomerStanding.disabled => SBadge(s.customerDisabled),
  CustomerStanding.deleted => SBadge(s.customerDeleted),
};
