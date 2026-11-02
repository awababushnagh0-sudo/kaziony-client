import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';

/// The terms and privacy policy. Not written yet, so the page says so.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
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
