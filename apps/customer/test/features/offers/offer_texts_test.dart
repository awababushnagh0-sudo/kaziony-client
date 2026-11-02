import 'package:customer/core/l10n/generated/customer_localizations_en.dart';
import 'package:customer/features/offers/presentation/offer_texts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

void main() {
  final s = CustomerLocalizationsEn();

  /// When an offer ending [after] `now` (Monday at noon) says it ends.
  Future<String> ends(WidgetTester tester, Duration after) async {
    late String text;
    await tester.pumpWidget(
      Localizations(
        locale: const Locale('en'),
        // As in the app: these load the dates' words.
        delegates: StellarLocalizations.localizationsDelegates,
        child: Builder(
          // A new key each time, so each call builds again.
          key: UniqueKey(),
          builder: (context) {
            text = s.ends(context, offer(endsAt: now.add(after)), now);
            return const SizedBox();
          },
        ),
      ),
    );
    return text;
  }

  testWidgets('minutes in its last hour', (tester) async {
    expect(await ends(tester, const Duration(minutes: 30)), 'Ends in 30 min');
  });

  testWidgets('the time today', (tester) async {
    // The time's own format puts a narrow space before PM.
    expect(
      await ends(tester, const Duration(hours: 5)),
      startsWith('Until 5:00'),
    );
  });

  testWidgets('the weekday within the week ahead', (tester) async {
    expect(await ends(tester, const Duration(days: 3)), 'Until Thursday');
    expect(await ends(tester, const Duration(days: 6)), 'Until Sunday');
  });

  testWidgets('the date further out, where a weekday would repeat', (
    tester,
  ) async {
    expect(await ends(tester, const Duration(days: 7)), 'Until Nov 9');
    expect(await ends(tester, const Duration(days: 20)), 'Until Nov 22');
  });
}
