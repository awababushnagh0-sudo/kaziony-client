import 'package:admin/core/l10n/generated/admin_localizations_en.dart';
import 'package:admin/features/activity/domain/activity_entry.dart';
import 'package:admin/features/activity/presentation/activity_texts.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes.dart';

void main() {
  final s = AdminLocalizationsEn();

  test('says what was done', () {
    expect(activityActionText(s, sampleActivity()), 'Edited a store');
    expect(
      activityActionText(s, sampleActivity(action: 'offer.remove')),
      'Took an offer down',
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
        ActivityChange(field: 'branches.0.name', value: 'Center'),
        ActivityChange(field: 'branches.0.latitude', value: '32.9'),
        ActivityChange(field: 'branches.1.name', value: 'Airport'),
      ],
    );
    expect(activityFieldsText(entry), 'name, branches');
  });
}
