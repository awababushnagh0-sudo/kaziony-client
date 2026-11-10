import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/store.dart';
import 'add_location_view_model.dart';
import 'widgets/place_fields.dart';

/// Another place of [store]'s brand, opened as a store of its own. Pops
/// with the new store.
class AddLocationDialog extends AppView {
  const AddLocationDialog({required this.store, super.key});

  final StoreDetails store;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final provider = addLocationViewModel(store.id);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    Future<void> submit() async {
      final created = await viewModel.submit();
      if (created != null && context.mounted) Navigator.pop(context, created);
    }

    final failure = state.failure;
    return SDialog(
      title: s.addLocationTitle(store.name),
      width: 640,
      primaryLabel: s.addLocationButton,
      onPrimary: submit,
      busy: state.submitting,
      body: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SText(s.addLocationNote, color: SColor.textMuted),
            const Gap(Space.xl),
            SFormSection(
              title: s.sectionPlace,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PlaceFields(form: viewModel.form),
                  const Gap(Space.lg),
                  SFieldGrid(
                    children: [
                      STextInput(
                        controlName: 'phone',
                        label: s.locationPhone,
                        hint: '0912345678',
                        helper: s.locationPhoneHelp,
                        kind: TextInputKind.phone,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SFormSection(
              title: s.sectionHours,
              note: s.hoursNote,
              divider: false,
              child: const OpeningHoursFields(),
            ),
            if (failure != null) ...[
              const Gap(Space.lg),
              SText(failureMessage(context, failure), color: SColor.danger),
            ],
          ],
        ),
      ),
    );
  }
}
