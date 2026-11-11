import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/location.dart';
import '../domain/store.dart';
import 'location_lookup.dart';
import 'place_form.dart';

enum AddStoreProblem { phoneTakenByCustomer }

class AddStoreState {
  const AddStoreState({this.submitting = false, this.problem, this.failure});

  final bool submitting;
  final AddStoreProblem? problem;
  final AppFailure? failure;
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
      ...placeControls(ref),
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

  /// The created store, or null when the form is invalid or saving failed
  /// (the state or the form then says why).
  Future<CreatedStore?> submit() async {
    if (state.submitting) return null;
    state = const AddStoreState(submitting: true);
    final location = form.control('location');
    await settleLocation(location);
    if (!ref.mounted) return null;
    final place = form.valid ? readPlace(form) : null;
    if (place == null) {
      form.markAllAsTouched();
      state = const AddStoreState();
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
            place: place,
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
        state = const AddStoreState(
          problem: AddStoreProblem.phoneTakenByCustomer,
        );
      case Err(failure: ValidationFailure(code: LocationCodes.outsideLibya)):
        showOutsideLibya(location);
        state = const AddStoreState();
      case Err(:final failure):
        state = AddStoreState(failure: failure);
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
