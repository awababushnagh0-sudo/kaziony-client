import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/customer_localizations.dart';

/// Back to the page underneath, for pages without a bar (the welcome look):
/// on glass, so it reads over the brand's shapes in the corner.
class CustomerBackButton extends StatelessWidget {
  const CustomerBackButton({super.key});

  @override
  Widget build(BuildContext context) => SButton.glass(
    icon: SIcons.chevronBack,
    tooltip: CustomerLocalizations.of(context).back,
    onPressed: () => context.pop(),
  );
}
