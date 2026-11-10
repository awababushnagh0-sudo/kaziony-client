import 'package:admin/core/l10n/generated/admin_localizations_ar.dart';
import 'package:admin/core/l10n/generated/admin_localizations_en.dart';
import 'package:admin/features/activity/domain/activity_entry.dart';
import 'package:admin/features/activity/presentation/activity_texts.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';

void main() {
  final s = AdminLocalizationsEn();
  final ar = AdminLocalizationsAr();

  test('says what was done', () {
    expect(activityActionText(s, sampleActivity()), 'Edited a store');
    expect(
      activityActionText(s, sampleActivity(action: 'offer.remove')),
      'Took an offer down',
    );
    expect(
      activityActionText(s, sampleActivity(action: 'store.addLocation')),
      'Added a location',
    );
    expect(
      activityActionText(ar, sampleActivity(action: 'store.addLocation')),
      'إضافة فرع',
    );
  });

  test('tells disabling an account from enabling it', () {
    ActivityEntry status(String value) => sampleActivity(
      action: 'user.setStatus',
      changes: [ActivityChange(field: 'isActive', value: value)],
    );
    expect(activityActionText(s, status('false')), 'Disabled an account');
    expect(activityActionText(s, status('true')), 'Enabled an account');
  });

  test('shows an action it does not know yet as the backend names it', () {
    expect(
      activityActionText(s, sampleActivity(action: 'product.create')),
      'product.create',
    );
  });

  test('lists nested fields by their top field, once', () {
    final entry = sampleActivity(
      changes: const [
        ActivityChange(field: 'name', value: 'Pizza'),
        ActivityChange(field: 'area', value: 'Gargaresh'),
        ActivityChange(field: 'latitude', value: '32.9'),
        ActivityChange(field: 'openingHours.sat.0.open', value: '08:00'),
        ActivityChange(field: 'openingHours.sat.0.close', value: '23:00'),
        ActivityChange(field: 'openingHours.fri.0.open', value: '16:00'),
      ],
    );
    expect(activityFieldsText(entry), 'name, area, latitude, openingHours');
  });
}
