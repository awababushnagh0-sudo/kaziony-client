import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/customer_report.dart';
import 'reports_view_model.dart';

class ReportDialogState {
  const ReportDialogState({
    required this.report,
    this.removeStrike = false,
    this.endPause = false,
    this.saving = false,
    this.failure,
  });

  /// As it was opened, or as it is once resolved.
  final CustomerReport report;
  final bool removeStrike;
  final bool endPause;
  final bool saving;
  final AppFailure? failure;

  ReportDialogState copyWith({
    CustomerReport? report,
    bool? removeStrike,
    bool? endPause,
    bool? saving,
  }) => ReportDialogState(
    report: report ?? this.report,
    removeStrike: removeStrike ?? this.removeStrike,
    endPause: endPause ?? this.endPause,
    saving: saving ?? this.saving,
  );
}

/// One report, and resolving it: what our team found, and whether to take
/// back the booking's strike and end the customer's pause. Nothing is
/// taken back unless asked.
class ReportDialogViewModel extends ViewModel<ReportDialogState> {
  ReportDialogViewModel(this.opened);

  /// The longest note the backend keeps.
  static const resolutionMaxLength = 1000;

  final CustomerReport opened;
  late final FormGroup form;

  @override
  ReportDialogState build() {
    form = FormGroup({
      'resolution': FormControl<String>(
        validators: [Validators.maxLength(resolutionMaxLength)],
      ),
    });
    ref.onDispose(form.dispose);
    return ReportDialogState(report: opened);
  }

  void setRemoveStrike(bool value) =>
      state = state.copyWith(removeStrike: value);

  void setEndPause(bool value) => state = state.copyWith(endPause: value);

  /// True once resolved; otherwise the form or the state says why.
  Future<bool> resolve() async {
    if (state.saving || !state.report.open) return false;
    if (form.invalid) {
      form.markAllAsTouched();
      return false;
    }
    state = state.copyWith(saving: true);
    final report = state.report;
    final result = await ref
        .read(reportRepositoryProvider)
        .resolve(
          report.id,
          ReportResolution(
            removeStrike: state.removeStrike && report.hasStrike,
            endPause: state.endPause && report.customer.pausedUntil != null,
            note: form.control('resolution').value as String?,
          ),
        );
    if (!ref.mounted) return false;
    switch (result) {
      case Ok(:final value):
        ref.invalidate(reportsPageProvider);
        state = ReportDialogState(report: value);
        return true;
      case Err(:final failure):
        state = ReportDialogState(
          report: report,
          removeStrike: state.removeStrike,
          endPause: state.endPause,
          failure: failure,
        );
        return false;
    }
  }
}

final reportDialogViewModel = NotifierProvider.autoDispose
    .family<ReportDialogViewModel, ReportDialogState, CustomerReport>(
      ReportDialogViewModel.new,
    );
