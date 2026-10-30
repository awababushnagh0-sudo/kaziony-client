import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/l10n/generated/partner_localizations.dart';
import 'package:partner/features/offers/presentation/widgets/offer_labels.dart';

void main() {
  test('offerLength says how long an offer runs, in its biggest units', () {
    final s = lookupPartnerLocalizations(const Locale('en'));
    expect(offerLength(s, const Duration(days: 2, hours: 3)), '2 days');
    expect(offerLength(s, const Duration(hours: 9, minutes: 30)), '9 h 30 min');
    expect(offerLength(s, const Duration(hours: 3)), '3 h');
    expect(offerLength(s, const Duration(minutes: 45)), '45 min');
  });
}
