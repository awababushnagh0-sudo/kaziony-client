import 'package:kernel/kernel.dart';

import '../../../core/list/list_controller.dart';
import '../../bookings/domain/booking_status.dart';
import '../domain/customer.dart';
import 'customers_view_model.dart';

/// One customer's page, and our team's actions on them.
class CustomerDetailsViewModel extends AsyncViewModel<CustomerDetails> {
  CustomerDetailsViewModel(this.customerId);

  final String customerId;

  CustomerRepository get _customers => ref.read(customerRepositoryProvider);

  @override
  Future<CustomerDetails> build() async {
    final result = await ref.watch(customerRepositoryProvider).get(customerId);
    return switch (result) {
      Ok(:final value) => value,
      Err(:final failure) => throw failure,
    };
  }

  Future<Result<CustomerDetails>> endPause() =>
      _apply(_customers.endPause(customerId));

  Future<Result<CustomerDetails>> takeBackStrike(String strikeId) =>
      _apply(_customers.takeBackStrike(customerId, strikeId));

  /// Disabling also cancels the bookings waiting for them, so their page
  /// is read again after.
  Future<Result<void>> setActive({required bool active}) async {
    final result = await _customers.setActive(customerId, active: active);
    if (result is Ok && ref.mounted) {
      if (await _customers.get(customerId) case Ok(:final value)
          when ref.mounted) {
        _show(value);
      }
    }
    return result;
  }

  Future<Result<CustomerDetails>> _apply(
    Future<Result<CustomerDetails>> change,
  ) async {
    final result = await change;
    if (result case Ok(:final value) when ref.mounted) _show(value);
    return result;
  }

  void _show(CustomerDetails customer) {
    state = AsyncData(customer);
    // The list beneath shows where they stand, and their bookings which
    // gave a strike.
    ref
      ..invalidate(customerPageProvider)
      ..invalidate(customerBookingPageProvider(customerId));
  }
}

final customerDetailsViewModel = AsyncNotifierProvider.autoDispose
    .family<CustomerDetailsViewModel, CustomerDetails, String>(
      CustomerDetailsViewModel.new,
    );

/// A customer's bookings: the status filter and page.
final customerBookingQueryProvider = NotifierProvider.autoDispose
    .family<ListController<BookingStatus>, CustomerBookingQuery, String>(
      (_) => ListController(),
    );

/// The current page of a customer's bookings, the latest first.
final customerBookingPageProvider = FutureProvider.autoDispose
    .family<CustomerBookingPage, String>(
      (ref, customerId) => loadPage(
        (query) =>
            ref.watch(customerRepositoryProvider).bookings(customerId, query),
        ref.watch(customerBookingQueryProvider(customerId)),
      ),
    );
