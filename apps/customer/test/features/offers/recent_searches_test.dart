import 'dart:convert';

import 'package:customer/features/offers/domain/recent_searches.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

void main() {
  late MemorySettingsStore settings;
  late ProviderContainer container;

  setUp(() {
    settings = MemorySettingsStore();
    container = ProviderContainer(
      overrides: testOverrides(kind: AppKind.customer, settings: settings),
    );
    addTearDown(container.dispose);
    container.listen(recentSearchesProvider, (_, _) {});
  });

  RecentSearches recents() => container.read(recentSearchesProvider.notifier);
  List<String> saved() =>
      (jsonDecode(settings.values['search.recent']!) as List).cast<String>();

  test('newest first, once whatever the case, and remembered', () async {
    await recents().add('kunafa');
    await recents().add(' cake ');
    await recents().add('Kunafa');

    expect(container.read(recentSearchesProvider), ['Kunafa', 'cake']);
    expect(saved(), ['Kunafa', 'cake']);
  });

  test('keeps only the newest few', () async {
    for (var i = 0; i < RecentSearches.max + 2; i++) {
      await recents().add('search $i');
    }

    final searches = container.read(recentSearchesProvider);
    expect(searches, hasLength(RecentSearches.max));
    expect(searches.first, 'search ${RecentSearches.max + 1}');
  });

  test('removes one, or all', () async {
    await recents().add('kunafa');
    await recents().add('cake');

    await recents().remove('kunafa');
    expect(saved(), ['cake']);

    await recents().clear();
    expect(container.read(recentSearchesProvider), isEmpty);
    expect(saved(), isEmpty);
  });

  test('a search added while loading keeps what was saved', () async {
    container.dispose();
    settings.values['search.recent'] = jsonEncode(['kunafa']);
    container = ProviderContainer(
      overrides: testOverrides(kind: AppKind.customer, settings: settings),
    );
    addTearDown(container.dispose);
    container.listen(recentSearchesProvider, (_, _) {});

    await recents().add('cake');

    expect(container.read(recentSearchesProvider), ['cake', 'kunafa']);
  });
}
