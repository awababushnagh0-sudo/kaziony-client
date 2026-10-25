import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import 'edit_offer_view_model.dart';
import 'new_offer_screen.dart';
import 'offer_form_checks.dart';
import 'offer_view_model.dart';

/// Changes an offer's title, description or end time.
class EditOfferScreen extends AppView {
  const EditOfferScreen({required this.offerId, super.key});

  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offer = ref.watch(offerViewModel(offerId));
    if (offer.hasValue) return _EditOfferForm(offerId: offerId);
    return SScaffold(
      title: PartnerLocalizations.of(context).editOfferTitle,
      body: SAsyncView(
        value: offer,
        onRetry: () => ref.invalidate(offerViewModel(offerId)),
        builder: (_, _) => const SizedBox.shrink(),
      ),
    );
  }
}

class _EditOfferForm extends AppView {
  const _EditOfferForm({required this.offerId});

  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final provider = editOfferViewModel(offerId);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    Future<void> save() async {
      if (await viewModel.save() && context.mounted) {
        SSnack.success(context, s.saved);
        context.pop();
      }
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return SScaffold(
      title: s.editOfferTitle,
      scrollable: true,
      bottom: SButton(
        label: s.save,
        onPressed: save,
        loading: state.saving,
        expand: true,
      ),
      body: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.lg,
          children: [
            STextInput(controlName: 'title', label: s.offerTitleLabel),
            STextInput(
              controlName: 'description',
              label: s.descriptionLabel,
              kind: TextInputKind.multiline,
              maxLength: 1000,
            ),
            SDateTimeInput(
              controlName: 'endsAt',
              label: s.endsLabel,
              firstDate: today,
              lastDate: today.add(OfferChecks.maxDuration),
              presets: endPresets(s),
              validationMessages: endMessages(s),
            ),
            if (state.failure case final failure?)
              SText(failureMessage(context, failure), color: SColor.danger),
          ],
        ),
      ),
    );
  }
}
