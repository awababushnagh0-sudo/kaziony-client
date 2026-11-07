import 'package:customer/core/routes/routes.dart';
import 'package:customer/core/widgets/customer_shell.dart';
import 'package:customer/features/bookings/domain/booking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../fakes.dart';
import '../support/pump_app.dart';

void main() {
  late FakeBookingsRepository bookings;

  setUp(() => bookings = FakeBookingsRepository());

  StatefulShellBranch tab(String path) => StatefulShellBranch(
    routes: [GoRoute(path: path, builder: (_, _) => SText('$path page'))],
  );

  Future<void> open(WidgetTester tester, {String initial = Routes.home}) =>
      pumpCustomerPages(
        tester,
        initial: initial,
        routes: [
          StatefulShellRoute.indexedStack(
            builder: (_, _, shell) => CustomerShell(shell: shell),
            branches: [
              tab(Routes.home),
              tab(Routes.search),
              tab(Routes.bookings),
              tab(Routes.account),
            ],
          ),
          stubPage(Routes.bookingPattern, 'pass page'),
        ],
        overrides: [
          bookingsRepositoryProvider.overrideWithValue(bookings),
          minuteClockProvider.overrideWith((ref) => Stream.value(now)),
          secondClockProvider.overrideWith((ref) => Stream.value(now)),
          sessionProvider.overrideWith(() => SignedInSession(customer())),
        ],
      );

  testWidgets('a booking to pick up floats above the tabs, counting down', (
    tester,
  ) async {
    await open(tester);

    expect(find.text('Your booking is ready for pickup'), findsOneWidget);
    expect(find.text('42:05'), findsOneWidget);
    // The Bookings tab counts it.
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.text('Your booking is ready for pickup'));
    await tester.pumpAndSettle();
    expect(find.text('pass page'), findsOneWidget);
  });

  testWidgets('the Bookings tab lists it instead', (tester) async {
    await open(tester, initial: Routes.bookings);

    expect(find.text('Your booking is ready for pickup'), findsNothing);
  });

  testWidgets('nothing floats once there is nothing to pick up', (
    tester,
  ) async {
    bookings.bookings = [booking(status: BookingStatus.pickedUp)];
    await open(tester);

    expect(find.text('Your booking is ready for pickup'), findsNothing);
    expect(find.text('1'), findsNothing);
  });
}
