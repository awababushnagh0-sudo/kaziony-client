import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/location.dart';
import '../domain/store.dart';

/// Validation error keys for the location field.
abstract final class LocationErrors {
  static const unreadable = 'location';
  static const outsideLibya = 'outsideLibya';

  /// The backend couldn't be reached; saving checks again.
  static const unchecked = 'unchecked';
}

/// "32.8872, 13.1913": how a point shows in the location field.
String coordinatesText(LatLng point) => '${point.latitude}, ${point.longitude}';

/// The location field, a Google Maps link or coordinates. As it's typed,
/// the backend reads the point in it (following short links) into [point];
/// the field shows a spinner meanwhile.
FormControl<String> locationControl(Ref ref, FormControl<LatLng> point) {
  final read = Validators.debounced(
    Validators.delegateAsync((control) => _read(ref, control, point)),
    600,
  );
  return FormControl<String>(
    validators: [Validators.required],
    asyncValidators: [
      // Debounced by nothing, so the control doesn't wait either: [read]
      // waits for typing to pause, and a known point needs no wait.
      Validators.debounced(
        Validators.delegateAsync(
          (control) async =>
              // The point it already shows (a saved store's): nothing to
              // read.
              _known(control, point) ? null : await read.validate(control),
        ),
        0,
      ),
    ],
  );
}

bool _known(AbstractControl<Object?> control, FormControl<LatLng> point) {
  final known = point.value;
  return known != null && _link(control) == coordinatesText(known);
}

String _link(AbstractControl<Object?> control) =>
    (control.value as String?)?.trim() ?? '';

Future<Map<String, Object?>?> _read(
  Ref ref,
  AbstractControl<Object?> control,
  FormControl<LatLng> point,
) async {
  if (_known(control, point)) return null;
  final link = _link(control);
  point.value = null;
  if (link.isEmpty) return null;
  final result = await ref.read(storeRepositoryProvider).resolveLocation(link);
  // Typed on meanwhile: this answer is for an older link.
  if (!ref.mounted || _link(control) != link) return null;
  if (result is Err) {
    // The admin is watching the spinner: say why right away, without
    // waiting for them to leave the field.
    control.markAsTouched();
  }
  switch (result) {
    case Ok(:final value):
      point.value = value;
      return null;
    case Err(failure: ValidationFailure(code: LocationCodes.outsideLibya)):
      return {LocationErrors.outsideLibya: true};
    case Err(failure: ValidationFailure()):
      return {LocationErrors.unreadable: true};
    case Err():
      return {LocationErrors.unchecked: true};
  }
}

/// Waits for the location field's check, checking again first when the
/// backend couldn't be reached last time.
Future<void> settleLocation(AbstractControl<Object?> location) async {
  if (location.hasError(LocationErrors.unchecked)) {
    location.updateValueAndValidity();
  }
  if (location.pending) {
    await location.statusChanged.firstWhere((_) => !location.pending);
  }
}

/// Marks the location field when saving was refused because the place is
/// outside Libya.
void showOutsideLibya(AbstractControl<Object?> location) => location
  ..setErrors({LocationErrors.outsideLibya: true})
  ..markAsTouched();
