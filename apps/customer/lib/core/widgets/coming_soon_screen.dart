import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/customer_localizations.dart';

/// A tab whose page isn't built yet.
class ComingSoonScreen extends AppView {
  const ComingSoonScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SScaffold(
    title: title,
    body: Center(
      child: SText(
        CustomerLocalizations.of(context).comingSoon,
        color: SColor.textMuted,
      ),
    ),
  );
}
