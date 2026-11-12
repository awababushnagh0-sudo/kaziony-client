import 'package:admin/features/stores/data/api_store_repository.dart';
import 'package:admin/features/stores/domain/store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart' as api;

const _category = {
  'id': 'cat-sweets',
  'slug': 'sweets',
  'nameAr': 'حلويات',
  'nameEn': 'Sweets',
  'iconUrl': null,
  'sortOrder': 1,
  'isActive': true,
};

Map<String, Object?> _details({
  String city = 'TRIPOLI',
  Object? openingHours,
}) => {
  'id': 'store-1',
  'name': 'حلويات الساحل',
  'city': city,
  'area': 'حي الأندلس',
  'address': 'شارع جرابة',
  'latitude': 32.871,
  'longitude': 13.115,
  'openingHours': openingHours,
  'logoUrl': null,
  'coverUrl': null,
  'phone': '+218912345678',
  'email': null,
  'facebookUrl': null,
  'instagramUrl': null,
  'pickupInstructions': null,
  'ratingAverage': null,
  'ratingCount': 0,
  'isActive': false,
  'wasLive': false,
  // A kind this version doesn't know yet is left out.
  'missingToGoLive': ['LOGO', 'SOMETHING_NEW'],
  'createdAt': '2026-11-10T12:00:00.000Z',
  'category': _category,
  'members': [
    {
      'role': 'OWNER',
      'userId': 'u1',
      'name': 'Ahmed',
      'phone': '+218911111111',
      'isActive': true,
      'mustChangePassword': false,
    },
  ],
};

StoreDetails _read(Map<String, Object?> json) =>
    storeDetailsFromDto(api.StoreDetailDto.fromJson(json));

const _place = StorePlace(
  city: City.tripoli,
  area: 'Gargaresh',
  latitude: 32.85,
  longitude: 13.1,
  openingHours: OpeningHours({
    Weekday.sat: [
      OpeningShift(opens: 8 * 60, closes: 13 * 60),
      OpeningShift(opens: 16 * 60, closes: 23 * 60),
    ],
  }),
);

void main() {
  test('a store is one place, with its area', () {
    final store = _read(
      _details(
        openingHours: {
          'sat': [
            {'open': '08:00', 'close': '13:00'},
            {'open': '16:00', 'close': '23:00'},
          ],
          'fri': <Object?>[],
        },
      ),
    );

    expect(store.label, 'حلويات الساحل · حي الأندلس');
    expect(store.city, City.tripoli);
    expect(store.address, 'شارع جرابة');
    expect(store.latitude, 32.871);
    expect(store.longitude, 13.115);
    expect(
      store.openingHours,
      const OpeningHours({
        Weekday.sat: [
          OpeningShift(opens: 8 * 60, closes: 13 * 60),
          OpeningShift(opens: 16 * 60, closes: 23 * 60),
        ],
        Weekday.fri: [],
      }),
    );
    expect(store.teamCount, 1);
    expect(store.isActive, isFalse);
    expect(store.missingToGoLive, [GoLiveItem.logo]);
  });

  test('reads its photos', () {
    final store = _read({
      ..._details(),
      'logoUrl': 'https://img.test/logo.jpg',
      'coverUrl': 'https://img.test/cover.jpg',
    });

    expect(store.logoUrl, 'https://img.test/logo.jpg');
    expect(store.coverUrl, 'https://img.test/cover.jpg');
  });

  test('a store without hours has none', () {
    expect(_read(_details()).openingHours, OpeningHours.none);
  });

  test('a city this version does not know reads as none', () {
    expect(_read(_details(city: 'BENGHAZI')).city, isNull);
  });

  test('a row of the list carries the area', () {
    final row = storeSummaryFromDto(
      api.StoreListItemDto.fromJson({
        'id': 'store-2',
        'name': 'حلويات الساحل',
        'area': 'بن عاشور',
        'logoUrl': null,
        'isActive': true,
        'category': _category,
        'createdAt': '2026-11-10T12:00:00.000Z',
      }),
    );

    expect(row.area, 'بن عاشور');
    expect(row.label, 'حلويات الساحل · بن عاشور');
  });

  test('a new store sends its place, and no hours when it has none', () {
    final json = createStoreBody(
      const NewStore(
        name: 'Sweet Coast',
        categoryId: 'cat-sweets',
        phone: '+218912345678',
        place: StorePlace(
          city: City.tripoli,
          area: 'Gargaresh',
          latitude: 32.9,
          longitude: 13.2,
        ),
        ownerName: 'Ahmed',
        ownerPhone: '+218912345678',
      ),
    ).toJson();

    expect(json['city'], api.City.tripoli);
    expect(json['latitude'], 32.9);
    expect(json['longitude'], 13.2);
    expect(json['area'], 'Gargaresh');
    expect(json['phone'], '+218912345678');
    expect(json.containsKey('address'), isFalse);
    expect(json.containsKey('email'), isFalse);
    expect(json.containsKey('openingHours'), isFalse);
  });

  test('opening hours go as days to periods', () {
    final json = createStoreBody(
      const NewStore(
        name: 'Sweet Coast',
        categoryId: 'cat-sweets',
        phone: '+218912345678',
        place: _place,
        ownerName: 'Ahmed',
        ownerPhone: '+218912345678',
      ),
    ).toJson();

    expect(json['area'], 'Gargaresh');
    expect(json['openingHours'], {
      'sat': [
        {'open': '08:00', 'close': '13:00'},
        {'open': '16:00', 'close': '23:00'},
      ],
    });
  });

  test('an edit leaves the place alone unless it is given', () {
    final json = updateStoreBody(
      const EditedStore(
        name: 'Sweet Coast',
        categoryId: 'cat-sweets',
        phone: '+218912345678',
      ),
    ).toJson();

    expect(json['name'], 'Sweet Coast');
    // Empty clears the store's own optional fields; the phone is always
    // there.
    expect(json['phone'], '+218912345678');
    expect(json['email'], '');
    for (final field in [
      'city',
      'area',
      'address',
      'latitude',
      'longitude',
      'openingHours',
    ]) {
      expect(json.containsKey(field), isFalse, reason: field);
    }
  });

  test('a moved place clears what was emptied, hours included', () {
    final json = updateStoreBody(
      const EditedStore(
        name: 'Sweet Coast',
        categoryId: 'cat-sweets',
        phone: '+218912345678',
        place: StorePlace(
          city: City.tripoli,
          area: 'Gargaresh',
          latitude: 32.9,
          longitude: 13.2,
        ),
      ),
    ).toJson();

    expect(json['city'], api.City.tripoli);
    // Every store has an area: it's changed, never cleared.
    expect(json['area'], 'Gargaresh');
    expect(json['address'], '');
    expect(json['latitude'], 32.9);
    expect(json['openingHours'], isEmpty);
  });

  test("another location sends its phone, or none for the brand's", () {
    final withPhone = addLocationBody(
      const NewLocation(place: _place, phone: '+218947654321'),
    ).toJson();
    final without = addLocationBody(const NewLocation(place: _place)).toJson();

    expect(withPhone['phone'], '+218947654321');
    expect(withPhone['area'], 'Gargaresh');
    expect(withPhone['openingHours'], isA<Map<String, Object?>>());
    expect(without.containsKey('phone'), isFalse);
  });
}
