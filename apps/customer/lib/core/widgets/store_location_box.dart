import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../features/offers/domain/offer.dart';
import '../../features/offers/presentation/offer_texts.dart';
import '../l10n/generated/customer_localizations.dart';
import 'customer_illustrations.dart';

/// Where to pick up, on an offer's and a store's page: a box with a little
/// map, the area, the address and how far, that opens the way there in the
/// phone's maps; under it, as the store said them, its hours today and its
/// phone, which calls. It fills the width it's given: pages pad it.
class StoreLocationBox extends AppView {
  const StoreLocationBox({required this.location, super.key});

  final StoreLocation location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    final details = storeLocationDetails(context, ref, location, now: now);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [
        SBoxTile(
          illustration: CustomerIllustrations.map,
          title: locationName(s, location),
          subtitle: locationWhere(s, location),
          action: SIcons.navigate,
          actionLabel: s.storeGetDirections,
          onTap: () => openDirections(context, ref, location),
        ),
        if (details.isNotEmpty) SListGroup(children: details),
      ],
    );
  }
}

/// The way to [location] as a row of a list group, as on a booking's
/// pass: where it is, with the word for directions at its end.
Widget storeDirectionsTile(
  BuildContext context,
  WidgetRef ref,
  StoreLocation location,
) {
  final s = CustomerLocalizations.of(context);
  return SListTile(
    icon: SIcons.navigate,
    title: locationName(s, location),
    subtitle: locationWhere(s, location),
    trailing: SText(
      s.directionsAction,
      weight: SFontWeight.bold,
      color: SColor.primary,
    ),
    onTap: () => openDirections(context, ref, location),
  );
}

/// [location]'s hours on [now]'s day and its phone, as rows of a list
/// group: those the store said.
List<Widget> storeLocationDetails(
  BuildContext context,
  WidgetRef ref,
  StoreLocation location, {
  required DateTime now,
}) {
  final s = CustomerLocalizations.of(context);
  final hours = hoursOn(context, location.hours, now);
  final phone = location.phone;
  return [
    if (hours != null) SListTile(icon: SIcons.clock, title: hours),
    if (phone != null)
      SListTile(
        icon: SIcons.phone,
        title: formatLibyanPhone(phone),
        trailing: SText(
          s.callAction,
          weight: SFontWeight.bold,
          color: SColor.primary,
        ),
        onTap: () => _open(
          context,
          ref,
          Uri(scheme: 'tel', path: phone),
          failed: s.callFailed,
        ),
      ),
  ];
}

/// What a place is called: its area, else its address.
String locationName(CustomerLocalizations s, StoreLocation location) =>
    location.area ?? location.address ?? s.pickupWhereTitle;

/// Under [locationName]: the address (when the area is the name) and how
/// far it is.
String? locationWhere(CustomerLocalizations s, StoreLocation location) {
  final parts = [
    if (location.area != null) ?location.address,
    if (location.distanceKm case final km?) s.distance(km),
  ];
  return parts.isEmpty ? null : parts.join(' · ');
}

/// "Open today 8:00 AM – 11:00 PM", or "Closed today", on [day]; null when
/// the store hasn't said.
String? hoursOn(BuildContext context, OpeningHours hours, DateTime day) {
  final s = CustomerLocalizations.of(context);
  final times = hours.on(day);
  if (times == null) return null;
  if (times.isEmpty) return s.closedToday;
  final language = Localizations.localeOf(context).languageCode;
  final local = day.toLocal();
  final midnight = DateTime(local.year, local.month, local.day);
  String at(int minutes) => formatTime(
    midnight.add(Duration(minutes: minutes)),
    languageCode: language,
  );
  return s.openToday(
    times
        .map((shift) => s.hoursBetween(at(shift.opens), at(shift.closes)))
        .join(s.listSeparator),
  );
}

/// Opens the way to [location] in the phone's maps, or says it couldn't.
Future<void> openDirections(
  BuildContext context,
  WidgetRef ref,
  StoreLocation location,
) => _open(
  context,
  ref,
  directionsLink(location.point),
  failed: CustomerLocalizations.of(context).storeDirectionsFailed,
);

/// Opens [link] in the phone's own app, or says [failed].
Future<void> _open(
  BuildContext context,
  WidgetRef ref,
  Uri link, {
  required String failed,
}) async {
  final opened = await ref.read(linkOpenerProvider).open(link);
  if (!opened && context.mounted) SSnack.error(context, failed);
}
