import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../domain/offer.dart';
import 'home_view_model.dart';
import 'offers_view_model.dart';
import 'widgets/offers_list.dart';

/// The Search tab: every offer around, searched, sorted and filtered by
/// kind of store.
class SearchScreen extends AppView {
  const SearchScreen({super.key});

  static const initial = OffersFilter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final filter = ref.watch(offersFilterProvider(initial));
    final controller = ref.read(offersFilterProvider(initial).notifier);
    final categories = ref.watch(categoriesProvider).value ?? const [];
    Future<void> chooseSort() async {
      final sort = await SSheet.choose<OfferSort>(
        context,
        title: s.sortTitle,
        selected: filter.sort,
        options: [
          for (final sort in OfferSort.values)
            RadioOption(value: sort, label: sortName(s, sort)),
        ],
      );
      if (sort != null) controller.setSort(sort);
    }

    return SScaffold(
      title: s.searchTitle,
      padded: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Space.lg,
              Space.sm,
              Space.lg,
              Space.md,
            ),
            child: SSearchField(
              hint: s.searchHint,
              initialValue: filter.search,
              autofocus: true,
              onChanged: controller.setSearch,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Space.lg),
            child: Row(
              spacing: Space.sm,
              children: [
                SPill(
                  label: sortName(s, filter.sort),
                  icon: SIcons.sortable,
                  selected: true,
                  activeColor: SColor.text,
                  onTap: chooseSort,
                ),
                SPill(
                  label: s.allCategories,
                  selected: filter.categoryId == null,
                  onTap: () => controller.setCategory(null),
                ),
                for (final category in categories)
                  SPill(
                    label: category.name(language),
                    selected: filter.categoryId == category.id,
                    onTap: () => controller.setCategory(category.id),
                  ),
              ],
            ),
          ),
          const Gap(Space.md),
          const Expanded(child: OffersList(initial: initial)),
        ],
      ),
    );
  }
}

String sortName(CustomerLocalizations s, OfferSort sort) => switch (sort) {
  OfferSort.nearest => s.sortNearest,
  OfferSort.endingSoon => s.sortEndingSoon,
  OfferSort.newest => s.sortNewest,
  OfferSort.biggestDiscount => s.sortBiggestDiscount,
};
