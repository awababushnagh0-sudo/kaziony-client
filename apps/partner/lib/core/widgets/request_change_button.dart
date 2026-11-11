import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/partner_localizations.dart';

/// Asks our team for what only they change (the store's place, a new
/// place, who works there, turning it on): opens a WhatsApp chat with
/// them, [message] typed in.
class RequestChangeButton extends AppStatefulView {
  const RequestChangeButton({required this.message, this.label, super.key});

  /// In the app's language, naming the store, so our team knows which.
  final String message;

  /// What the button says, when not "Request a change".
  final String? label;

  @override
  AppViewState<RequestChangeButton> createState() =>
      _RequestChangeButtonState();
}

class _RequestChangeButtonState extends AppViewState<RequestChangeButton> {
  var _opening = false;

  Future<void> _open() async {
    final s = PartnerLocalizations.of(context);
    setState(() => _opening = true);
    // It loads with the page; when that failed, it's tried again.
    if (ref.read(supportContactProvider).hasError) {
      ref.invalidate(supportContactProvider);
    }
    try {
      final support = await ref.read(supportContactProvider.future);
      final opened = await ref
          .read(linkOpenerProvider)
          .open(support.whatsappMessage(widget.message));
      if (!opened && mounted) SSnack.error(context, s.linkNotOpened);
    } on AppFailure catch (failure) {
      if (mounted) SSnack.error(context, failureMessage(context, failure));
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Loaded with the page, so the chat opens at once.
    ref.watch(supportContactProvider);
    return SButton.secondary(
      label: widget.label ?? PartnerLocalizations.of(context).requestChange,
      icon: SIcons.chat,
      expand: true,
      loading: _opening,
      onPressed: _open,
    );
  }
}
