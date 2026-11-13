import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../../store/domain/store.dart';
import '../../../store/presentation/store_view_model.dart';
import '../../domain/offer_hours.dart';
import '../offer_form_checks.dart';

/// When the offer ends (the form's `endsAt`), as posting and editing ask
/// it; under it, in orange, when the store is closed for part of the
/// offer's time or all of it ([OfferHours]). It can still be posted: the
/// hours may be about to change.
class OfferEndInput extends AppView {
  const OfferEndInput({required this.endsAt, super.key});

  /// What the field holds now.
  final DateTime? endsAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final now = ref.watch(minuteClockProvider).value ?? ServerClock.now();
    final clock = libyaClock(now);
    final today = DateTime(clock.year, clock.month, clock.day);
    final store = ref.watch(storeViewModel).value;
    final endsAt = this.endsAt;
    final hours = store == null || endsAt == null
        ? null
        : OfferHours.of(_schedule(store), now: now, endsAt: endsAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        SDateTimeInput(
          controlName: 'endsAt',
          label: s.endsLabel,
          firstDate: today,
          lastDate: today.add(OfferChecks.maxDuration),
          presets: _presets(s, now),
          validationMessages: {
            OfferChecks.endsInPastKey: (_) => s.endsInPast,
            OfferChecks.endsTooLateKey: (_) => s.endsTooLate,
          },
        ),
        if (hours != null) _HoursNote(hours, now: now),
      ],
    );
  }

  /// The hours customers see; a break the store is on now ends soon, and
  /// isn't the offer's to say.
  static StoreSchedule _schedule(Store store) =>
      StoreSchedule(weekly: store.openingHours, special: store.specialHours);
}

/// One-tap end times: tonight (while it's still to come), tomorrow night,
/// in 3 days, in a week, all at 23:00 in Libya.
List<DateTimePreset> _presets(PartnerLocalizations s, DateTime now) {
  final today = libyaClock(now);
  DateTime night(int days) =>
      libyaTime(today.year, today.month, today.day + days, 23);
  return [
    if (night(0).isAfter(now)) DateTimePreset(s.endsTonight, night(0)),
    DateTimePreset(s.endsTomorrow, night(1)),
    DateTimePreset(s.endsIn3Days, night(3)),
    DateTimePreset(s.endsInAWeek, night(7)),
  ];
}

class _HoursNote extends StatelessWidget {
  const _HoursNote(this.hours, {required this.now});

  final OfferHours hours;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    String at(DateTime time) =>
        formatWhen(time, languageCode: language, now: now);
    return switch (hours) {
      ClosedThroughOffer(:final opensAt) => SAlert.warning(
        title: s.offerClosedThroughTitle,
        message: s.offerClosedThroughMessage(at(opensAt)),
      ),
      OutsideHours(:final opensAt, :final closesAt) => SAlert.warning(
        title: s.offerOutsideHoursTitle,
        message: [
          if (opensAt != null) s.offerOpensLater(at(opensAt)),
          if (closesAt != null) s.offerClosesBeforeEnd(at(closesAt)),
        ].join(' '),
      ),
    };
  }
}
