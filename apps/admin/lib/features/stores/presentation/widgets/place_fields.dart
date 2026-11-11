import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/admin_localizations.dart';
import '../../domain/location.dart';
import '../hours_text.dart';
import '../location_lookup.dart';
import '../place_form.dart';

/// Where a store is: its city, area, address and location, bound to the
/// `placeControls` in [form].
class PlaceFields extends StatelessWidget {
  const PlaceFields({required this.form, this.columns = 2, super.key});

  final FormGroup form;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SFieldGrid(
          columns: columns,
          children: [
            SSelectInput<City>(
              controlName: 'city',
              label: s.placeCity,
              required: true,
              options: [
                for (final city in City.values)
                  SelectOption(city, _cityName(s, city)),
              ],
            ),
            STextInput(
              controlName: 'area',
              label: s.placeArea,
              required: true,
              hint: s.placeAreaHint,
              helper: s.placeAreaHelp,
            ),
            STextInput(controlName: 'address', label: s.placeAddress),
          ],
        ),
        const Gap(Space.lg),
        _LocationInput(point: form.control('point')),
      ],
    );
  }
}

/// The location field, saying under it which point the backend read.
class _LocationInput extends StatelessWidget {
  const _LocationInput({required this.point});

  final AbstractControl<Object?> point;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    return StreamBuilder<Object?>(
      stream: point.valueChanges,
      builder: (context, _) {
        final found = point.value as LatLng?;
        return STextInput(
          controlName: 'location',
          label: s.placeLocation,
          hint: 'https://maps.google.com/...',
          helper: found == null
              ? s.placeLocationHelp
              : s.locationFound(
                  found.latitude.toStringAsFixed(5),
                  found.longitude.toStringAsFixed(5),
                ),
          kind: TextInputKind.url,
          required: true,
          validationMessages: {
            LocationErrors.unreadable: (_) => s.invalidLocation,
            LocationErrors.outsideLibya: (_) => s.locationOutsideLibya,
            LocationErrors.unchecked: (_) => s.locationUnchecked,
          },
        );
      },
    );
  }
}

/// A field per day for when the store is open, bound to the
/// `placeControls` of the enclosing form.
class OpeningHoursFields extends StatelessWidget {
  const OpeningHoursFields({this.columns = 2, super.key});

  final int columns;

  @override
  Widget build(BuildContext context) {
    final s = AdminLocalizations.of(context);
    return SFieldGrid(
      columns: columns,
      children: [
        for (final day in Weekday.values)
          STextInput(
            controlName: hoursField(day),
            label: _dayName(s, day),
            hint: '08:00-23:00',
            validationMessages: {hoursError: (_) => s.invalidHours},
          ),
      ],
    );
  }
}

String _cityName(AdminLocalizations s, City city) => switch (city) {
  City.tripoli => s.cityTripoli,
};

String _dayName(AdminLocalizations s, Weekday day) => switch (day) {
  Weekday.sat => s.daySat,
  Weekday.sun => s.daySun,
  Weekday.mon => s.dayMon,
  Weekday.tue => s.dayTue,
  Weekday.wed => s.dayWed,
  Weekday.thu => s.dayThu,
  Weekday.fri => s.dayFri,
};
