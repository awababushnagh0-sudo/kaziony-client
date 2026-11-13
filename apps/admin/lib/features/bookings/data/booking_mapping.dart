import 'package:offers_api/admin.dart' as api;

import '../domain/booking_status.dart';

/// Null for a status this version doesn't know.
BookingStatus? bookingStatusOf(api.ClaimStatus status) => switch (status) {
  api.ClaimStatus.reserved => BookingStatus.waiting,
  api.ClaimStatus.outForDelivery => BookingStatus.outForDelivery,
  api.ClaimStatus.redeemed => BookingStatus.pickedUp,
  api.ClaimStatus.expired => BookingStatus.missed,
  api.ClaimStatus.cancelled => BookingStatus.cancelled,
  api.ClaimStatus.$unknown => null,
};

/// The server's filter for [status].
api.ClaimStatus claimStatusOf(BookingStatus status) => switch (status) {
  BookingStatus.waiting => api.ClaimStatus.reserved,
  BookingStatus.outForDelivery => api.ClaimStatus.outForDelivery,
  BookingStatus.pickedUp => api.ClaimStatus.redeemed,
  BookingStatus.missed => api.ClaimStatus.expired,
  BookingStatus.cancelled => api.ClaimStatus.cancelled,
};

/// Null when not cancelled, or for a reason this version doesn't know.
CancelReason? cancelReasonOf(api.CancelReason? reason) => switch (reason) {
  api.CancelReason.customer => CancelReason.customer,
  api.CancelReason.storeClosed => CancelReason.storeClosed,
  api.CancelReason.hoursChanged => CancelReason.hoursChanged,
  api.CancelReason.notDelivered => CancelReason.notDelivered,
  api.CancelReason.offerRemoved => CancelReason.offerRemoved,
  api.CancelReason.storeOff => CancelReason.storeOff,
  api.CancelReason.accountDisabled => CancelReason.accountDisabled,
  api.CancelReason.$unknown || null => null,
};
