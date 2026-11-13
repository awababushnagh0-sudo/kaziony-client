import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/record/record_form.dart';
import '../domain/location.dart';
import '../domain/store.dart';
import 'hours_text.dart';
import 'location_lookup.dart';
import 'place_form.dart';
import 'store_details_view_model.dart';

/// A store's own fields and its place, edited on its page.
class StoreFormViewModel extends RecordForm<StoreDetails> {
  StoreFormViewModel(this.storeId);

  final String storeId;

  @override
  AsyncNotifierProvider<StoreDetailsViewModel, StoreDetails> get record =>
      storeDetailsViewModel(storeId);

  @override
  Map<String, AbstractControl<Object?>> fields() => {
    'name': FormControl<String>(
      validators: [Validators.required, Validators.maxLength(100)],
    ),
    'categoryId': FormControl<String>(validators: [Validators.required]),
    'pickupInstructions': FormControl<String>(
      validators: [Validators.maxLength(500)],
    ),
    'phone': FormControl<String>(
      validators: [Validators.required, SValidators.libyanPhone],
    ),
    'email': FormControl<String>(
      validators: [SValidators.email, Validators.maxLength(255)],
    ),
    'facebookUrl': FormControl<String>(validators: [SValidators.url]),
    'instagramUrl': FormControl<String>(validators: [SValidators.url]),
    'delivers': FormControl<bool>(value: false),
    // Empty: customers call the store's phone.
    'deliveryPhone': FormControl<String>(validators: [SValidators.libyanPhone]),
    ...placeControls(ref),
  };

  @override
  Map<String, Object?> valuesOf(StoreDetails store) {
    final LatLng point = (latitude: store.latitude, longitude: store.longitude);
    return {
      'name': store.name,
      'categoryId': store.category.id,
      'pickupInstructions': store.pickupInstructions,
      'phone': formatLibyanPhone(store.phone),
      'email': store.email,
      'facebookUrl': store.facebookUrl,
      'instagramUrl': store.instagramUrl,
      'delivers': store.delivers,
      'deliveryPhone': switch (store.deliveryPhone) {
        final phone? => formatLibyanPhone(phone),
        null => null,
      },
      'city': store.city,
      'area': store.area,
      'address': store.address,
      'point': point,
      'location': coordinatesText(point),
      for (final day in Weekday.values)
        hoursField(day): hoursText(store.openingHours.days[day]),
    };
  }

  /// For [submit]: the save this one is, cancels the bookings its hours miss.
  bool _cancelBookings = false;

  /// Waits for a new location to be read first. With [cancelBookings],
  /// hours that close the store before bookings waiting are due cancel
  /// them.
  @override
  Future<Result<StoreDetails>?> save({bool cancelBookings = false}) async {
    await settleLocation(form.control('location'));
    if (!ref.mounted) return null;
    _cancelBookings = cancelBookings;
    return super.save();
  }

  @override
  Future<Result<StoreDetails>> submit() async {
    final result = await ref
        .read(record.notifier)
        .save(
          EditedStore(
            name: text('name')!,
            categoryId: form.control('categoryId').value as String,
            pickupInstructions: text('pickupInstructions'),
            phone: normalizeLibyanPhone(text('phone')!)!,
            email: text('email'),
            facebookUrl: text('facebookUrl'),
            instagramUrl: text('instagramUrl'),
            delivers: form.control('delivers').value as bool? ?? false,
            deliveryPhone: switch (text('deliveryPhone')) {
              final phone? => normalizeLibyanPhone(phone),
              null => null,
            },
            place: differs(placeFields) ? readPlace(form) : null,
          ),
          cancelBookings: _cancelBookings,
        );
    if (result
        case Err(failure: ValidationFailure(code: LocationCodes.outsideLibya))
        when ref.mounted) {
      showOutsideLibya(form.control('location'));
    }
    return result;
  }
}

final storeFormViewModel = NotifierProvider.autoDispose
    .family<StoreFormViewModel, RecordFormState, String>(
      StoreFormViewModel.new,
    );
