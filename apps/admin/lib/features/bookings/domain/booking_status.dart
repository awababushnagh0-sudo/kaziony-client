/// Where a customer's booking stands, as our team says it.
enum BookingStatus {
  /// Waiting to be picked up.
  waiting,
  outForDelivery,
  pickedUp,

  /// Not picked up in time: it gave the customer a strike.
  missed,
  cancelled,
}

/// Why a booking was cancelled, and so who did it: only [customer] was the
/// customer's doing.
enum CancelReason {
  customer,
  storeClosed,
  hoursChanged,
  notDelivered,
  offerRemoved,
  storeOff,
  accountDisabled,
}
