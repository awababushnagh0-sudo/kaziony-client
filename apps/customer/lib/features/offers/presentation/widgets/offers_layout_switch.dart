import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/customer_localizations.dart';
import '../offers_layout.dart';

/// Picks how lists of offers are shown, cards or a list; every list follows.
class OffersLayoutSwitch extends AppView {
  const OffersLayoutSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    return SSegmented<OffersLayout>(
      segments: [
        SSegment(
          value: OffersLayout.cards,
          icon: SIcons.viewCards,
          tooltip: s.viewAsCards,
        ),
        SSegment(
          value: OffersLayout.list,
          icon: SIcons.viewList,
          tooltip: s.viewAsList,
        ),
      ],
      selected: ref.watch(offersLayoutProvider),
      onChanged: ref.read(offersLayoutProvider.notifier).set,
    );
  }
}
