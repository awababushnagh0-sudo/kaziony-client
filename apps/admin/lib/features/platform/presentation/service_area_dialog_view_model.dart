import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/service_area.dart';
import 'service_areas_view_model.dart';

class ServiceAreaDialogState {
  const ServiceAreaDialogState({
    this.saving = false,
    this.deleting = false,
    this.failure,
  });

  final bool saving;
  final bool deleting;
  final AppFailure? failure;

  bool get busy => saving || deleting;
}

/// Validation error key for a center that isn't "latitude, longitude".
const coordinatesError = 'coordinates';

/// Reads "32.85, 13.18" (as Google Maps copies a point) into latitude and
/// longitude. Null when it isn't two numbers on the globe.
(double, double)? parseCoordinates(Object? value) {
  final parts = '${value ?? ''}'.split(',').map((part) => part.trim());
  if (parts.length != 2) return null;
  final latitude = double.tryParse(parts.first);
  final longitude = double.tryParse(parts.last);
  if (latitude == null || longitude == null) return null;
  if (latitude.abs() > 90 || longitude.abs() > 180) return null;
  return (latitude, longitude);
}

/// Adds a service area, or changes or deletes [area].
class ServiceAreaDialogViewModel extends ViewModel<ServiceAreaDialogState> {
  ServiceAreaDialogViewModel(this.area);

  final ServiceArea? area;
  late final FormGroup form;

  @override
  ServiceAreaDialogState build() {
    final area = this.area;
    form = FormGroup({
      'nameAr': FormControl<String>(
        value: area?.nameAr,
        validators: [Validators.required, Validators.maxLength(60)],
      ),
      'nameEn': FormControl<String>(
        value: area?.nameEn,
        validators: [Validators.required, Validators.maxLength(60)],
      ),
      'center': FormControl<String>(
        value: area == null ? null : '${area.latitude}, ${area.longitude}',
        validators: [
          Validators.required,
          Validators.delegate(
            (control) =>
                control.value == null || parseCoordinates(control.value) != null
                ? null
                : {coordinatesError: true},
          ),
        ],
      ),
      'radiusKm': FormControl<String>(
        value: area == null ? null : '${area.radiusKm}',
        validators: [
          Validators.required,
          SValidators.wholeNumberBetween(
            minServiceAreaRadiusKm,
            maxServiceAreaRadiusKm,
          ),
        ],
      ),
      'isActive': FormControl<bool>(value: area?.isActive ?? true),
    });
    ref.onDispose(form.dispose);
    return const ServiceAreaDialogState();
  }

  /// True once saved; otherwise the form or the state says why.
  Future<bool> save() async {
    if (state.busy) return false;
    if (form.invalid) {
      form.markAllAsTouched();
      return false;
    }
    state = const ServiceAreaDialogState(saving: true);
    final (latitude, longitude) = parseCoordinates(
      form.control('center').value,
    )!;
    final draft = ServiceAreaDraft(
      nameAr: (form.control('nameAr').value as String).trim(),
      nameEn: (form.control('nameEn').value as String).trim(),
      latitude: latitude,
      longitude: longitude,
      radiusKm: SValidators.wholeNumber(form.control('radiusKm').value)!,
      isActive: form.control('isActive').value as bool,
    );
    final repository = ref.read(serviceAreaRepositoryProvider);
    final area = this.area;
    final result = area == null
        ? await repository.create(draft)
        : await repository.update(area.id, draft);
    return _done(result);
  }

  /// True once deleted.
  Future<bool> delete() async {
    final area = this.area;
    if (area == null || state.busy) return false;
    state = const ServiceAreaDialogState(deleting: true);
    return _done(await ref.read(serviceAreaRepositoryProvider).delete(area.id));
  }

  bool _done(Result<Object?> result) {
    if (!ref.mounted) return false;
    switch (result) {
      case Ok():
        ref.invalidate(serviceAreasViewModel);
        state = const ServiceAreaDialogState();
        return true;
      case Err(:final failure):
        state = ServiceAreaDialogState(failure: failure);
        return false;
    }
  }
}

final serviceAreaDialogViewModel = NotifierProvider.autoDispose
    .family<ServiceAreaDialogViewModel, ServiceAreaDialogState, ServiceArea?>(
      ServiceAreaDialogViewModel.new,
    );
