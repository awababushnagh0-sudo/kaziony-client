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
      _BelowRegular(regular);

  /// An end time still to come, at most [maxDuration] away.
  static const Validator<dynamic> endsAt = _EndsAt();

  /// Tonight at 23:00 when it's still to come, else tomorrow's: when most
  /// end-of-day offers end.
  static DateTime defaultEnd([DateTime? now]) {
    final at = now ?? DateTime.now();
    final tonight = DateTime(at.year, at.month, at.day, 23);
    return tonight.isAfter(at) ? tonight : tonight.add(const Duration(days: 1));
  }
}

class _BelowRegular extends Validator<dynamic> {
  const _BelowRegular(this.regular);

  final String regular;

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    final price = value is String ? parsePrice(value) : null;
    // An empty or malformed price is the other checks' to report.
    if (price == null) return null;
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
    final now = DateTime.now();
    if (!value.isAfter(now)) return {OfferChecks.endsInPastKey: true};
    if (value.isAfter(now.add(OfferChecks.maxDuration))) {
      return {OfferChecks.endsTooLateKey: true};
    }
    return null;
  }
}
