import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import 'edit_store_info_view_model.dart';

class EditStoreInfoScreen extends AppView {
  const EditStoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final state = ref.watch(editStoreInfoViewModel);
    final viewModel = ref.read(editStoreInfoViewModel.notifier);

    Future<void> save() async {
      if (await viewModel.save() && context.mounted) {
        SSnack.success(context, s.saved);
        context.pop();
      }
    }

    return SScaffold(
      title: s.storeInfoTitle,
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
            STextInput(
              controlName: 'description',
              label: s.descriptionLabel,
              kind: TextInputKind.multiline,
              maxLength: 1000,
            ),
            STextInput(
              controlName: 'phone',
              label: s.phoneLabel,
              kind: TextInputKind.phone,
            ),
            STextInput(
              controlName: 'email',
              label: s.emailLabel,
              kind: TextInputKind.email,
            ),
            STextInput(
              controlName: 'facebookUrl',
              label: s.facebookLabel,
              kind: TextInputKind.url,
              hint: 'https://facebook.com/…',
            ),
            STextInput(
              controlName: 'instagramUrl',
              label: s.instagramLabel,
              kind: TextInputKind.url,
              hint: 'https://instagram.com/…',
              isLast: true,
              onSubmitted: save,
            ),
            if (state.failure case final failure?)
              SText(failureMessage(context, failure), color: SColor.danger),
          ],
        ),
      ),
    );
  }
}
