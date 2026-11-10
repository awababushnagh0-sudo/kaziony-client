import 'package:admin/core/l10n/generated/admin_localizations.dart';
import 'package:admin/features/system/presentation/system_format.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

void main() {
  final s = lookupAdminLocalizations(const Locale('en'));

  test('sizes in the unit that keeps them short', () {
    expect(formatBytes(s, 512), '0.5 KB');
    expect(formatBytes(s, 1536), '1.5 KB');
    expect(formatBytes(s, 48 * 1024 * 1024), '48 MB');
    expect(formatBytes(s, 250 * 1024 * 1024), '250 MB');
    expect(formatBytes(s, 3 * 1024 * 1024 * 1024), '3 GB');
  });

  test('times, and a dash for nothing to time', () {
    expect(formatMs(s, 12.34), '12.3 ms');
    expect(formatMs(s, 120.6), '121 ms');
    expect(formatMs(s, 40), '40 ms');
    expect(formatMs(s, null), '–');
  });

  test('ratios as percentages', () {
    expect(formatRatio(s, 0.125), '12.5%');
    expect(formatRatio(s, 1), '100%');
    expect(formatRatio(s, 0), '0%');
  });

  test('uptime in its two biggest units', () {
    expect(formatUptime(s, const Duration(minutes: 7)), '7 min');
    expect(formatUptime(s, const Duration(hours: 2, minutes: 5)), '2 h 5 min');
    expect(formatUptime(s, const Duration(days: 3, hours: 4)), '3 d 4 h');
  });
}
