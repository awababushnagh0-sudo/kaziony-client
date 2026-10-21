import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/location.dart';
import '../domain/store.dart';

enum AddStoreProblem { phoneTakenByCustomer }

class AddStoreState {
  const AddStoreState({
    this.submitting = false,
    this.problem,
    this.failure,
    this.location,
  });

  final bool submitting;
  final AddStoreProblem? problem;
  final AppFailure? failure;

  /// The point the backend read from the location field, shown under it so
  /// the admin can check it.
  final LatLng? location;
}

/// Validation error keys for the location field.
abstract final class LocationErrors {
  static const unreadable = 'location';
  static const outsideLibya = 'outsideLibya';

  /// The backend couldn't be reached; submitting checks again.
  static const unchecked = 'unchecked';
}

class AddStoreViewModel extends ViewModel<AddStoreState> {
  late final FormGroup form;

  @override
  AddStoreState build() {
    form = FormGroup({
      'name': FormControl<String>(
        validators: [Validators.required, Validators.maxLength(100)],
      ),
      'categoryId': FormControl<String>(validators: [Validators.required]),
      'phone': FormControl<String>(validators: [SValidators.libyanPhone]),
      'email': FormControl<String>(
        validators: [SValidators.email, Validators.maxLength(255)],
      ),
      'branchName': FormControl<String>(
        validators: [Validators.required, Validators.maxLength(100)],
      ),
      // Almost every store starts in Tripoli.
      'city': FormControl<City>(
        value: City.tripoli,
        validators: [Validators.required],
      ),
      'area': FormControl<String>(validators: [Validators.maxLength(100)]),
      'address': FormControl<String>(validators: [Validators.maxLength(255)]),
      // The backend reads the point, following short links to the map. The
      // field shows a spinner meanwhile.
      'location': FormControl<String>(
        validators: [Validators.required],
        asyncValidators: [
          Validators.debounced(Validators.delegateAsync(_readLocation), 600),
        ],
      ),
      'ownerName': FormControl<String>(
        validators: [Validators.required, Validators.maxLength(100)],
      ),
      'ownerPhone': FormControl<String>(
        validators: [Validators.required, SValidators.libyanPhone],
      ),
    });
    ref.onDispose(form.dispose);
    return const AddStoreState();
  }

  Future<Map<String, dynamic>?> _readLocation(
    AbstractControl<dynamic> control,
  ) async {
    final link = (control.value as String?)?.trim() ?? '';
    _showLocation(null);
    if (link.isEmpty) return null;
    final result = await ref
        .read(storeRepositoryProvider)
        .resolveLocation(link);
    // Typed on meanwhile: this answer is for an older link.
    if (!ref.mounted || (control.value as String?)?.trim() != link) {
      return null;
    }
    if (result is Err) {
      // The admin is watching the spinner: say why right away, without
      // waiting for them to leave the field.
      control.markAsTouched();
    }
    switch (result) {
      case Ok(:final value):
        _showLocation(value);
        return null;
      case Err(failure: ValidationFailure(code: LocationCodes.outsideLibya)):
        return {LocationErrors.outsideLibya: true};
      case Err(failure: ValidationFailure()):
        return {LocationErrors.unreadable: true};
      case Err():
        return {LocationErrors.unchecked: true};
    }
  }

  void _showLocation(LatLng? location) => state = AddStoreState(
    submitting: state.submitting,
    problem: state.problem,
    failure: state.failure,
    location: location,
  );

  /// The created store, or null when the form is invalid or saving failed
  /// (the state then says why).
  Future<CreatedStore?> submit() async {
    if (state.submitting) return null;
    state = AddStoreState(submitting: true, location: state.location);
    final location = form.control('location');
    if (location.hasError(LocationErrors.unchecked)) {
      location.updateValueAndValidity();
    }
    if (location.pending) {
      await location.statusChanged.firstWhere((_) => !location.pending);
      if (!ref.mounted) return null;
    }
    final point = state.location;
    if (form.invalid || point == null) {
      form.markAllAsTouched();
      state = AddStoreState(location: point);
      return null;
    }

    String? text(String name) {
      final value = (form.control(name).value as String?)?.trim();
      return value == null || value.isEmpty ? null : value;
    }

    final phone = text('phone');
    final result = await ref
        .read(storeRepositoryProvider)
        .create(
          NewStore(
            name: text('name')!,
            categoryId: form.control('categoryId').value as String,
            phone: phone == null ? null : normalizeLibyanPhone(phone),
            email: text('email'),
            branch: NewBranch(
              name: text('branchName')!,
              city: form.control('city').value as City,
              area: text('area'),
              address: text('address'),
              latitude: point.latitude,
              longitude: point.longitude,
            ),
            ownerName: text('ownerName')!,
            ownerPhone: normalizeLibyanPhone(text('ownerPhone')!)!,
          ),
        );
    if (!ref.mounted) return null;

    switch (result) {
      case Ok(:final value):
        state = const AddStoreState();
        return value;
      // The only conflict: the owner's phone is a customer's account.
      case Err(failure: ConflictFailure()):
        state = AddStoreState(
          problem: AddStoreProblem.phoneTakenByCustomer,
          location: point,
        );
      case Err(:final failure):
        state = AddStoreState(failure: failure, location: point);
    }
    return null;
  }
}

final addStoreViewModel =
    NotifierProvider.autoDispose<AddStoreViewModel, AddStoreState>(
      AddStoreViewModel.new,
    );

/// Active categories for the category picker.
final categoriesProvider = FutureProvider.autoDispose<List<Category>>((
  ref,
) async {
  final result = await ref.watch(storeRepositoryProvider).categories();
  return switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
});
