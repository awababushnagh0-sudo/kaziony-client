import 'package:customer/features/location/domain/browse_location.dart';
import 'package:customer/features/offers/domain/offer.dart';
import 'package:customer/features/offers/presentation/home_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';

void main() {
  late FakeOffersRepository offers;
  late ProviderContainer container;

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
    container.listen(homeFeedProvider, (_, _) {});
  });

  test('loads a row for each sort, around the chosen place', () async {
    final feed = await container.read(homeFeedProvider.future);

    expect(feed.nearby, hasLength(1));
    expect(feed.isEmpty, isFalse);
    expect(offers.queries.map((q) => q.sort), [
      OfferSort.nearest,
      OfferSort.endingSoon,
      OfferSort.biggestDiscount,
      OfferSort.newest,
    ]);
    expect(offers.queries.every((q) => q.around == souqAlJuma), isTrue);
  });

  test('a category loads the rows again for it alone', () async {
    await container.read(homeFeedProvider.future);
    offers.queries.clear();

    container.read(homeCategoryProvider.notifier).select(bakery.id);
    await container.read(homeFeedProvider.future);

    expect(offers.queries, hasLength(4));
    expect(offers.queries.every((q) => q.categoryId == bakery.id), isTrue);
  });

  test('no offers around reads as empty', () async {
    offers.offers = [];
    container.invalidate(homeFeedProvider);

    expect((await container.read(homeFeedProvider.future)).isEmpty, isTrue);
  });

  test('a refresh that fails keeps the rows and says why', () async {
    await container.read(homeFeedProvider.future);
    offers.browseFailure = const NoConnectionFailure();

    final failure = await container.read(homeFeedProvider.notifier).refresh();

    expect(failure, isA<NoConnectionFailure>());
    expect(container.read(homeFeedProvider).value?.nearby, hasLength(1));
  });
}
