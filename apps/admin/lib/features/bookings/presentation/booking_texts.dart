import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/booking_status.dart';

/// Null for a status this version doesn't know.
String? bookingStatusText(AdminLocalizations s, BookingStatus? status) =>
    switch (status) {
      null => null,
      BookingStatus.waiting => s.bookingWaiting,
      BookingStatus.outForDelivery => s.bookingOutForDelivery,
      BookingStatus.pickedUp => s.bookingPickedUp,
      BookingStatus.missed => s.bookingMissed,
      BookingStatus.cancelled => s.bookingCancelled,
    };

/// A booking's status as a badge: green once picked up, orange when missed.
SBadge? bookingStatusBadge(AdminLocalizations s, BookingStatus? status) =>
    switch (bookingStatusText(s, status)) {
      null => null,
      final text => SBadge(
        text,
        tone: switch (status) {
          BookingStatus.pickedUp => BadgeTone.success,
          BookingStatus.missed => BadgeTone.warning,
          _ => BadgeTone.neutral,
        },
      ),
    };

/// Who cancelled it and why; null for a reason this version doesn't know.
String? cancelReasonText(AdminLocalizations s, CancelReason? reason) =>
    switch (reason) {
      null => null,
      CancelReason.customer => s.cancelledByCustomer,
      CancelReason.storeClosed => s.cancelledStoreClosed,
      CancelReason.hoursChanged => s.cancelledHoursChanged,
      CancelReason.notDelivered => s.cancelledNotDelivered,
      CancelReason.offerRemoved => s.cancelledOfferRemoved,
      CancelReason.storeOff => s.cancelledStoreOff,
      CancelReason.accountDisabled => s.cancelledAccountDisabled,
    };
