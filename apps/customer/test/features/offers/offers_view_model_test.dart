import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/offers/domain/offer.dart';
import 'package:customer/features/offers/presentation/offers_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';

void main() {
  late FakeOffersRepository offers;
  late ProviderContainer container;
  const initial = OffersFilter(sort: OfferSort.endingSoon);

  setUp(() {
    offers = FakeOffersRepository();
    container = ProviderContainer(
      overrides: [
        ...testOverrides(kind: AppKind.customer),
        offersRepositoryProvider.overrideWithValue(offers),
        browseLocationProvider.overrideWith(
          () => BrowseLocationController(
            const BrowseLocation(souqAlJuma, pinned: false),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    container.listen(offersViewModel(initial), (_, _) {});
  });

  OffersFilterController filter() =>
      container.read(offersFilterProvider(initial).notifier);

  Future<OffersQuery> lastQuery() async {
    await container.read(offersViewModel(initial).future);
    return offers.queries.last;
  }

  test('starts from what it was opened with', () async {
    final query = await lastQuery();

    expect(query.sort, OfferSort.endingSoon);
    expect(query.around, souqAlJuma);
  });

  test('a sort or a category lists again', () async {
    filter()
      ..setSort(OfferSort.biggestDiscount)
      ..setCategory(bakery.id);
    final query = await lastQuery();

    expect(query.sort, OfferSort.biggestDiscount);
    expect(query.categoryId, bakery.id);

    filter().setCategory(null);
    expect((await lastQuery()).categoryId, isNull);
  });

  test('searches once typing pauses, trimmed', () async {
    filter()
      ..setSearch('kun')
      ..setSearch(' kunafa ');
    expect(container.read(offersFilterProvider(initial)).search, '');

    await Future<void>.delayed(OffersFilterController.searchDelay * 2);

    expect((await lastQuery()).search, 'kunafa');
    expect(offers.queries.where((q) => q.search == 'kun'), isEmpty);
  });

  test('an emptied field, or the search key, searches at once', () async {
    filter().searchNow('kunafa');
    expect((await lastQuery()).search, 'kunafa');

    filter().setSearch('');
    expect((await lastQuery()).search, '');
  });
}
