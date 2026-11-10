import '../../../core/l10n/generated/admin_localizations.dart';

const _kb = 1024;

/// "48.2 MB": [bytes] in the unit that keeps it short.
String formatBytes(AdminLocalizations s, int bytes) {
  if (bytes < _kb * _kb) return s.unitKb(_short(bytes / _kb));
  if (bytes < _kb * _kb * _kb) return s.unitMb(_short(bytes / (_kb * _kb)));
  return s.unitGb(_short(bytes / (_kb * _kb * _kb)));
}

/// "120 ms", or a dash when there's nothing to time.
String formatMs(AdminLocalizations s, num? ms) =>
    ms == null ? '–' : s.unitMs(_short(ms.toDouble()));

/// "12.5%" for a [ratio] of 0.125.
String formatRatio(AdminLocalizations s, double ratio) =>
    s.unitPercent(_short(ratio * 100));

/// "3 d 4 h", "2 h 5 min", "7 min": how long something has been up.
String formatUptime(AdminLocalizations s, Duration uptime) {
  final days = uptime.inDays;
  final hours = uptime.inHours % 24;
  final minutes = uptime.inMinutes % 60;
  if (days > 0) return s.uptimeDays(days, hours);
  if (hours > 0) return s.uptimeHours(hours, minutes);
  return s.uptimeMinutes(minutes);
}

/// Whole above 100, else one decimal without a trailing ".0".
String _short(double value) {
  if (value >= 100) return value.round().toString();
  final fixed = value.toStringAsFixed(1);
  return fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
}
