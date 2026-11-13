import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// Checks shared by posting and editing an offer.
abstract final class OfferChecks {
  static const belowRegularKey = 'belowRegular';
  static const endsInPastKey = 'endsInPast';
  static const endsTooLateKey = 'endsTooLate';

  /// The backend's limit, counted from now.
  static const maxDuration = Duration(days: 30);

  /// An offer price lower than [regular] ("8.000").
  static Validator<dynamic> belowRegular(String regular) =>
      _BelowRegular(() => regular);

  /// The same, against a regular price typed on the same form: nothing to
  /// check while [regular] is null.
  static Validator<dynamic> belowRegularOf(String? Function() regular) =>
      _BelowRegular(regular);

  /// An end time still to come, at most [maxDuration] away.
  static const Validator<dynamic> endsAt = _EndsAt();

  /// Tonight at 23:00 in Libya when it's still to come, else tomorrow's:
  /// when most end-of-day offers end.
  static DateTime defaultEnd([DateTime? now]) {
    final at = now ?? ServerClock.now();
    final today = libyaClock(at);
    final tonight = libyaTime(today.year, today.month, today.day, 23);
    return tonight.isAfter(at)
        ? tonight
        : libyaTime(today.year, today.month, today.day + 1, 23);
  }
}

class _BelowRegular extends Validator<dynamic> {
  const _BelowRegular(this.regular);

  final String? Function() regular;

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    final price = value is String ? parsePrice(value) : null;
    // An empty or malformed price is the other checks' to report.
    if (price == null) return null;
    final regular = this.regular();
    if (regular == null) return null;
    return dirhamsOf(price) < dirhamsOf(regular)
        ? null
        : {OfferChecks.belowRegularKey: true};
  }
}

class _EndsAt extends Validator<dynamic> {
  const _EndsAt();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    if (value is! DateTime) return null;
    final now = ServerClock.now();
    if (!value.isAfter(now)) return {OfferChecks.endsInPastKey: true};
    if (value.isAfter(now.add(OfferChecks.maxDuration))) {
      return {OfferChecks.endsTooLateKey: true};
    }
    return null;
  }
}
