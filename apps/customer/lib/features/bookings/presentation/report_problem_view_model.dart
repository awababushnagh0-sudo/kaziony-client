import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../domain/booking.dart';
import 'booking_view_model.dart';

class ReportProblemState {
  const ReportProblemState({this.reason, this.sending = false, this.failure});

  /// Null until the customer picks one.
  final ReportReason? reason;
  final bool sending;
  final AppFailure? failure;
}

/// A report of a problem with one booking: why, and what happened in the
/// customer's words (needed for "something else"). Sent through the
/// booking's page, which then shows it.
class ReportProblemViewModel extends ViewModel<ReportProblemState> {
  ReportProblemViewModel(this.bookingId);

  final String bookingId;

  /// The server's limit.
  static const noteMaxLength = 500;

  late final FormGroup form;

  @override
  ReportProblemState build() {
    form = FormGroup({
      'note': FormControl<String>(
        validators: [Validators.maxLength(noteMaxLength)],
      ),
    });
    ref.onDispose(form.dispose);
    return const ReportProblemState();
  }

  void choose(ReportReason reason) {
    state = ReportProblemState(reason: reason);
    form.control('note').setValidators([
      Validators.maxLength(noteMaxLength),
      if (reason == ReportReason.other) Validators.required,
    ], autoValidate: true);
  }

  /// True once it's sent; otherwise what's wrong is marked on the form, or
  /// the failure is in the state.
  Future<bool> send() async {
    final reason = state.reason;
    if (reason == null || state.sending) return false;
    if (form.invalid) {
      form.markAllAsTouched();
      return false;
    }
    state = ReportProblemState(reason: reason, sending: true);
    final note = (form.control('note').value as String?)?.trim();
    final failure = await ref
        .read(bookingViewModel(bookingId).notifier)
        .report(reason, note: note == null || note.isEmpty ? null : note);
    if (!ref.mounted) return false;
    state = ReportProblemState(reason: reason, failure: failure);
    return failure == null;
  }
}

final reportProblemViewModel = NotifierProvider.autoDispose
    .family<ReportProblemViewModel, ReportProblemState, String>(
      ReportProblemViewModel.new,
    );
