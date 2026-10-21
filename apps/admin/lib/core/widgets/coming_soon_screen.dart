import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/admin_localizations.dart';

/// Stands in for the pages that come in the next steps.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    return SScaffold(
      title: title,
      body: SEmptyView(title: s.comingSoonTitle, message: s.comingSoonMessage),
    );
  }
}
