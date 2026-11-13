import 'package:customer/features/bookings/domain/booking.dart';
import 'package:customer/features/bookings/presentation/bookings_view_model.dart';
import 'package:customer/features/bookings/presentation/reserve_view_model.dart';
import 'package:customer/features/offers/domain/offer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';

void main() {
  late FakeBookingsRepository bookings;
  late ProviderContainer container;

  setUp(() {
    bookings = FakeBookingsRepository();
    container = ProviderContainer(
      overrides: [
        ...testOverrides(kind: AppKind.customer),
        bookingsRepositoryProvider.overrideWithValue(bookings),
      ],
    );
    addTearDown(container.dispose);
  });

  ReserveViewModel viewModelFor(Offer deal) {
    container.listen(reserveViewModel(deal), (_, _) {});
    return container.read(reserveViewModel(deal).notifier);
  }

  test('keeps the quantity within what is left and the limit', () {
    final deal = offer(remaining: 3, maxPerUser: 2);
    final viewModel = viewModelFor(deal);

    viewModel.setQuantity(5);
    expect(container.read(reserveViewModel(deal)).quantity, 2);
    viewModel.setQuantity(0);
    expect(container.read(reserveViewModel(deal)).quantity, 1);
  });

  test('an offer without counts or limit still caps the picker', () {
    expect(offer(limited: false, maxPerUser: null).maxReservable, 10);
    expect(offer(remaining: 1, maxPerUser: 4).maxReservable, 1);
  });

  test('never offers more than one booking takes', () {
    expect(offer(remaining: 500, maxPerUser: null).maxReservable, 100);
    expect(offer(remaining: 500, maxPerUser: 150).maxReservable, 100);
  });

  test('reserves the chosen quantity', () async {
    final deal = offer();
    final viewModel = viewModelFor(deal)..setQuantity(2);

    final made = await viewModel.reserve();

    expect(made?.id, 'k1');
    expect(bookings.reserved, [('o1', 2)]);
    expect(container.read(reserveViewModel(deal)).sending, isFalse);
  });

  test('keeps why it was refused', () async {
    bookings.reserveResult = const Err(ConflictFailure(null, 'SoldOut'));
    final deal = offer();
    final viewModel = viewModelFor(deal);

    expect(await viewModel.reserve(), isNull);
    expect(
      container.read(reserveViewModel(deal)).failure,
      isA<ConflictFailure>().having((f) => f.code, 'code', 'SoldOut'),
    );

    viewModel.clearFailure();
    expect(container.read(reserveViewModel(deal)).failure, isNull);
  });

  group('where the customer stands', () {
    Future<void> watchStanding() async {
      container.listen(bookingStandingProvider, (_, _) {});
      await container.read(bookingStandingProvider.future);
    }

    setUp(() {
      container = ProviderContainer(
        overrides: [
          ...testOverrides(kind: AppKind.customer),
          bookingsRepositoryProvider.overrideWithValue(bookings),
          sessionProvider.overrideWith(() => SignedInSession(customer())),
        ],
      );
      addTearDown(container.dispose);
    });

    test('is loaded again once reserved: one more is held', () async {
      await watchStanding();
      await viewModelFor(offer()).reserve();
      await container.read(bookingStandingProvider.future);

      expect(bookings.standingLoads, 2);
    });

    test('is loaded again when refused for it', () async {
      await watchStanding();
      bookings.reserveResult = const Err(ForbiddenFailure(code: 'ClaimBanned'));
      await viewModelFor(offer()).reserve();
      await container.read(bookingStandingProvider.future);

      expect(bookings.standingLoads, 2);
    });

    test('stays as it was when refused for the offer', () async {
      await watchStanding();
      bookings.reserveResult = const Err(ConflictFailure(null, 'SoldOut'));
      await viewModelFor(offer()).reserve();
      await container.read(bookingStandingProvider.future);

      expect(bookings.standingLoads, 1);
    });
  });
}
