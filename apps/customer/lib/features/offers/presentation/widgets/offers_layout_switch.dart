import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/customer_localizations.dart';
import '../offers_layout.dart';

/// Picks how the offers of a [place] are shown, cards or a list; every
/// list there follows.
class OffersLayoutSwitch extends AppView {
  const OffersLayoutSwitch({this.place = OffersPlace.lists, super.key});

  final OffersPlace place;

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
      selected: ref.watch(offersLayoutProvider(place)),
      onChanged: ref.read(offersLayoutProvider(place).notifier).set,
    );
  }
}
