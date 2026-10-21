import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/location.dart';
import '../domain/store.dart';

enum AddStoreProblem { phoneTakenByCustomer }

class AddStoreState {
  const AddStoreState({this.submitting = false, this.problem, this.failure});

  final bool submitting;
  final AddStoreProblem? problem;
  final AppFailure? failure;
}

/// Validation error keys for the location field.
abstract final class LocationErrors {
  static const unreadable = 'location';
  static const outsideLibya = 'outsideLibya';
}

class AddStoreViewModel extends ViewModel<AddStoreState> {
  late final FormGroup form;

  @override
  AddStoreState build() {
    final arabic = ref.read(localeProvider).languageCode == 'ar';
    form = FormGroup({
      'name': FormControl<String>(
        validators: [Validators.required, Validators.maxLength(100)],
      ),
      'categoryId': FormControl<String>(validators: [Validators.required]),
      'phone': FormControl<String>(validators: [SValidators.libyanPhone]),
      'branchName': FormControl<String>(
        validators: [Validators.required, Validators.maxLength(100)],
      ),
      // Almost every store starts in Tripoli.
      'city': FormControl<String>(
        value: arabic ? 'طرابلس' : 'Tripoli',
        validators: [Validators.required, Validators.maxLength(50)],
      ),
      'area': FormControl<String>(validators: [Validators.maxLength(100)]),
      'address': FormControl<String>(validators: [Validators.maxLength(255)]),
      'location': FormControl<String>(
        validators: [Validators.required, Validators.delegate(_location)],
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

  static Map<String, dynamic>? _location(AbstractControl<dynamic> control) {
    final value = control.value;
    if (value is! String || value.trim().isEmpty) return null;
    final point = parseLocation(value);
    if (point == null) return {LocationErrors.unreadable: true};
    if (!isInLibya(point)) return {LocationErrors.outsideLibya: true};
    return null;
  }

  /// The created store, or null when the form is invalid or saving failed
  /// (the state then says why).
  Future<CreatedStore?> submit() async {
    if (state.submitting) return null;
    if (form.invalid) {
      form.markAllAsTouched();
      return null;
    }
    state = const AddStoreState(submitting: true);

    String? text(String name) {
      final value = (form.control(name).value as String?)?.trim();
      return value == null || value.isEmpty ? null : value;
    }

    final point = parseLocation(text('location')!)!;
    final phone = text('phone');
    final result = await ref
        .read(storeRepositoryProvider)
        .create(
          NewStore(
            name: text('name')!,
            categoryId: form.control('categoryId').value as String,
            phone: phone == null ? null : normalizeLibyanPhone(phone),
            branch: NewBranch(
              name: text('branchName')!,
              city: text('city')!,
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
        state = const AddStoreState(
          problem: AddStoreProblem.phoneTakenByCustomer,
        );
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
