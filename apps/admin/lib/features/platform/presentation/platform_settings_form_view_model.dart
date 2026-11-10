import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/providers/access.dart';
import '../../../core/record/record_form.dart';
import '../domain/platform_settings.dart';
import 'platform_settings_view_model.dart';

/// The limits the server accepts.
const minBrowseRadiusKm = 1;
const maxBrowseRadiusKm = 100;
const minHoldMinutes = 30;
const maxHoldMinutes = 240;

/// The settings' fields. Editors see them but only admins change them.
class PlatformSettingsFormViewModel extends RecordForm<PlatformSettings> {
  @override
  AsyncNotifierProvider<PlatformSettingsViewModel, PlatformSettings>
  get record => platformSettingsViewModel;

  @override
  Map<String, AbstractControl<Object?>> fields() {
    final editor = !ref.read(isAdminProvider);
    return {
      'browseRadiusKm': FormControl<String>(
        validators: [
          Validators.required,
          SValidators.wholeNumberBetween(minBrowseRadiusKm, maxBrowseRadiusKm),
        ],
        disabled: editor,
      ),
      'holdMinutes': FormControl<String>(
        validators: [
          Validators.required,
          SValidators.wholeNumberBetween(minHoldMinutes, maxHoldMinutes),
        ],
        disabled: editor,
      ),
    };
  }

  @override
  Map<String, Object?> valuesOf(PlatformSettings settings) => {
    'browseRadiusKm': '${settings.browseRadiusKm}',
    'holdMinutes': '${settings.holdMinutes}',
  };

  @override
  Future<Result<PlatformSettings>> submit() => ref
      .read(record.notifier)
      .save(
        PlatformSettings(
          browseRadiusKm: SValidators.wholeNumber(
            form.control('browseRadiusKm').value,
          )!,
          holdMinutes: SValidators.wholeNumber(
            form.control('holdMinutes').value,
          )!,
        ),
      );
}

final platformSettingsFormViewModel =
    NotifierProvider.autoDispose<
      PlatformSettingsFormViewModel,
      RecordFormState
    >(PlatformSettingsFormViewModel.new);
