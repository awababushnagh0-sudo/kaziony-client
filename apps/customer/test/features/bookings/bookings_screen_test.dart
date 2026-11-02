import 'package:customer/core/routes/routes.dart';
import 'package:customer/features/bookings/presentation/bookings_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

import '../../support/pump_app.dart';

void main() {
  testWidgets('signed out, it opens the sign-in page', (tester) async {
    await pumpCustomerPages(
      tester,
      initial: Routes.bookings,
      routes: [
        GoRoute(
          path: Routes.bookings,
          builder: (_, _) => const BookingsScreen(),
        ),
        stubPage(Routes.signIn, 'sign-in page'),
      ],
    );

    expect(find.text('Sign in to see your bookings'), findsOneWidget);
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('sign-in page'), findsOneWidget);
  });
}
