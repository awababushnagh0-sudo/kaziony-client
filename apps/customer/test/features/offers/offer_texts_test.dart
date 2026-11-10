import 'package:customer/core/l10n/generated/customer_localizations_ar.dart';
import 'package:customer/core/l10n/generated/customer_localizations_en.dart';
import 'package:customer/features/offers/presentation/offer_texts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../fakes.dart';

void main() {
  final s = CustomerLocalizationsEn();

  /// What a card says about picking up an offer from [startsAt] to
  /// [endsAt], seen `now` (Monday at noon).
  Future<String> cardPickup(
    WidgetTester tester, {
    required DateTime startsAt,
    required DateTime endsAt,
  }) async {
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
            text = s.cardPickup(
              context,
              offer(startsAt: startsAt, endsAt: endsAt),
              now,
            );
            return const SizedBox();
          },
        ),
      ),
    );
    return text;
  }

  testWidgets('a window within one day: the day, then from and to', (
    tester,
  ) async {
    final text = await cardPickup(
      tester,
      startsAt: DateTime(2026, 11, 2, 16),
      endsAt: DateTime(2026, 11, 2, 21),
    );
    // The time's own format puts a narrow space before PM.
    expect(text, startsWith('Today 4:00'));
    expect(text, contains('– 9:00'));
  });

  testWidgets('over several days: the day it ends, then until when', (
    tester,
  ) async {
    final text = await cardPickup(
      tester,
      startsAt: now,
      endsAt: DateTime(2026, 11, 5, 21),
    );
    expect(text, startsWith('Thursday until 9:00'));
  });

  testWidgets('the date further out, where a weekday would repeat', (
    tester,
  ) async {
    final text = await cardPickup(
      tester,
      startsAt: now,
      endsAt: DateTime(2026, 11, 9, 21),
    );
    expect(text, startsWith('Nov 9 until 9:00'));
  });

  group('holdTime', () {
    test('in hours, minutes, or both', () {
      expect(s.holdTime(120), '2 hours');
      expect(s.holdTime(60), '1 hour');
      expect(s.holdTime(45), '45 minutes');
      expect(s.holdTime(90), '1 hour and 30 minutes');
    });

    test('in Arabic, as said: one, two, a few, many', () {
      final ar = CustomerLocalizationsAr();
      expect(ar.holdTime(60), 'ساعة');
      expect(ar.holdTime(120), 'ساعتان');
      expect(ar.holdTime(180), '3 ساعات');
      expect(ar.holdTime(12 * 60), '12 ساعة');
      expect(ar.holdTime(2), 'دقيقتان');
      expect(ar.holdTime(5), '5 دقائق');
      expect(ar.holdTime(45), '45 دقيقة');
      expect(ar.holdTime(90), 'ساعة و30 دقيقة');
      expect(ar.holdTitle(ar.holdTime(120)), 'عندك ساعتان للاستلام');
    });
  });
}
