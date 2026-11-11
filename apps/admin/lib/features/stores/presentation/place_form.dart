import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/location.dart';
import '../domain/store.dart';
import 'hours_text.dart';
import 'location_lookup.dart';

// The fields of a store's place, shared by every form that sets one: a new
// store, another location of a brand, and a store's own page. They go into
// the form's group as they are; PlaceFields and OpeningHoursFields show them.

/// The field of a day's hours.
String hoursField(Weekday day) => '${day.name}Hours';

/// Every place field but the location's text: the point stands for it.
final placeFields = [
  'city',
  'area',
  'address',
  'point',
  for (final day in Weekday.values) hoursField(day),
];

/// The place's controls, by name. Almost every store is in Tripoli.
Map<String, AbstractControl<Object?>> placeControls(Ref ref) {
  final point = FormControl<LatLng>();
  return {
    'city': FormControl<City>(
      value: City.tripoli,
      validators: [Validators.required],
    ),
    'area': FormControl<String>(
      validators: [Validators.required, Validators.maxLength(100)],
    ),
    'address': FormControl<String>(validators: [Validators.maxLength(255)]),
    // Filled before the location's text, so a saved store's point is known
    // by the time its text is checked and isn't sent to the backend again.
    'point': point,
    'location': locationControl(ref, point),
    for (final day in Weekday.values)
      hoursField(day): FormControl<String>(validators: [hoursValidator]),
  };
}

/// What [form]'s place fields say, or null without a point (still being
/// read, or not readable). Read it once the form is valid.
StorePlace? readPlace(FormGroup form) {
  final point = form.control('point').value as LatLng?;
  if (point == null) return null;

  String? text(String name) {
    final value = (form.control(name).value as String?)?.trim();
    return value == null || value.isEmpty ? null : value;
  }

  return StorePlace(
    city: form.control('city').value as City,
    area: text('area')!,
    address: text('address'),
    latitude: point.latitude,
    longitude: point.longitude,
    openingHours: OpeningHours({
      for (final day in Weekday.values) day: ?parseHours(text(hoursField(day))),
    }),
  );
}
