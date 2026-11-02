import 'package:customer/features/location/domain/browse_location.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:kernel/testing.dart';

import '../../fakes.dart';

void main() {
  late MemorySettingsStore settings;
  late ProviderContainer container;

  setUp(() {
    settings = MemorySettingsStore();
    container = ProviderContainer(
      overrides: testOverrides(kind: AppKind.customer, settings: settings),
    );
    addTearDown(container.dispose);
  });

  test('a pinned place is kept on the phone and read back', () async {
    await container
        .read(browseLocationProvider.notifier)
        .set(const BrowseLocation(souqAlJuma, pinned: true));

    final saved = await BrowseLocationController.readSaved(settings);
    expect(saved?.point, souqAlJuma);
    expect(saved?.pinned, isTrue);
  });

  test('the phone\'s location is kept as not pinned', () async {
    const point = GeoPoint(32.88, 13.19);
    await container
        .read(browseLocationProvider.notifier)
        .set(const BrowseLocation(point, pinned: false));

    final saved = await BrowseLocationController.readSaved(settings);
    expect(saved?.pinned, isFalse);
    expect(saved?.point, point);
  });

  test('nothing saved, or something unreadable, is no place', () async {
    expect(await BrowseLocationController.readSaved(settings), isNull);
    settings.values['browse.location'] = '{broken';
    expect(await BrowseLocationController.readSaved(settings), isNull);
  });

  test('loads what was saved when not handed it', () async {
    settings.values['browse.location'] = '{"latitude":32.9,"longitude":13.2}';
    expect(container.read(browseLocationProvider), isNull);
    await pumpEventQueue();
    expect(
      container.read(browseLocationProvider)?.point,
      const GeoPoint(32.9, 13.2),
    );
  });

  test('a service area covers what is within its radius', () {
    expect(tripoli.covers(souqAlJuma), isTrue);
    expect(tripoli.covers(zawiya), isFalse);
    expect(coveredBy(const [tripoli], souqAlJuma), isTrue);
    expect(coveredBy(const [], souqAlJuma), isFalse);
  });
}
