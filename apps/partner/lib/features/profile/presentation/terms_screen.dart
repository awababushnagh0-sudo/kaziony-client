import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';

/// The terms and conditions. Not written yet, so the page says so.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return SScaffold(
      title: s.termsTitle,
      body: SEmptyView(
        icon: SIcons.document,
        title: s.termsSoonTitle,
        message: s.termsSoonMessage,
      ),
    );
  }
}
