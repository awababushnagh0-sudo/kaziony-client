import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../domain/offer.dart';
import 'offer_texts.dart';
import 'offers_view_model.dart';
import 'widgets/offers_layout_switch.dart';
import 'widgets/offers_list.dart';

/// All of one home row ("See all"): its offers in a list that scrolls
/// down, under the row's name, as cards or tiles; the home page's kind of store, if one was
/// picked.
class SectionOffersScreen extends AppView {
  const SectionOffersScreen({required this.sort, this.categoryId, super.key});

  final OfferSort sort;
  final String? categoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) => SScaffold(
    title: CustomerLocalizations.of(context).section(sort),
    actions: const [OffersLayoutSwitch()],
    padded: false,
    body: OffersList(
      initial: OffersFilter(sort: sort, categoryId: categoryId),
    ),
  );
}
