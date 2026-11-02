import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';

/// For now only a hello: the offers nearby come next.
class HomeScreen extends AppView {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    return SScaffold(
      title: s.homeTitle,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SText.title(s.helloTitle, align: TextAlign.center),
            const Gap(Space.sm),
            SText(
              s.helloText,
              color: SColor.textMuted,
              align: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
