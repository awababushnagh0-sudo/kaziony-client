import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/store.dart';
import 'add_store_view_model.dart';

/// The form for a new store, its first branch and its owner's account.
/// Pops with the created store.
class AddStoreDialog extends AppView {
  const AddStoreDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final state = ref.watch(addStoreViewModel);
    final viewModel = ref.read(addStoreViewModel.notifier);
    final categories = ref.watch(categoriesProvider);
    final locale = Localizations.localeOf(context);

    Future<void> submit() async {
      final created = await viewModel.submit();
      if (created != null && context.mounted) Navigator.pop(context, created);
    }

    final error = switch (state) {
      AddStoreState(problem: AddStoreProblem.phoneTakenByCustomer) =>
        s.phoneTakenByCustomer,
      AddStoreState(:final failure?) => failureMessage(context, failure),
      _ => null,
    };

    return AppDialog(
      title: s.addStoreTitle,
      width: 640,
      primaryLabel: s.createStore,
      onPrimary: submit,
      busy: state.submitting,
      body: AppForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppFormSection(
              title: s.sectionStore,
              child: AppFieldGrid(
                children: [
                  AppTextInput(
                    controlName: 'name',
                    label: s.storeName,
                    required: true,
                    autofocus: true,
                  ),
                  switch (categories) {
                    AsyncError() => AppText(
                      s.categoriesFailed,
                      tone: TextTone.danger,
                    ),
                    _ => AppSelectInput<String>(
                      controlName: 'categoryId',
                      label: s.storeCategory,
                      hint: s.storeCategoryHint,
                      required: true,
                      options: [
                        for (final category
                            in categories.value ?? const <Category>[])
                          SelectOption(category.id, category.name(locale)),
                      ],
                    ),
                  },
                  AppTextInput(
                    controlName: 'phone',
                    label: s.storePhone,
                    hint: '0912345678',
                    kind: TextInputKind.phone,
                  ),
                ],
              ),
            ),
            AppFormSection(
              title: s.sectionBranch,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppFieldGrid(
                    children: [
                      AppTextInput(
                        controlName: 'branchName',
                        label: s.branchName,
                        hint: s.branchNameHint,
                        required: true,
                      ),
                      AppTextInput(
                        controlName: 'city',
                        label: s.branchCity,
                        required: true,
                      ),
                      AppTextInput(controlName: 'area', label: s.branchArea),
                      AppTextInput(
                        controlName: 'address',
                        label: s.branchAddress,
                      ),
                    ],
                  ),
                  const Gap(Space.lg),
                  AppTextInput(
                    controlName: 'location',
                    label: s.branchLocation,
                    hint: 'https://maps.google.com/...',
                    helper: s.branchLocationHelp,
                    kind: TextInputKind.url,
                    required: true,
                    validationMessages: {
                      LocationErrors.unreadable: (_) => s.invalidLocation,
                      LocationErrors.outsideLibya: (_) =>
                          s.locationOutsideLibya,
                    },
                  ),
                ],
              ),
            ),
            AppFormSection(
              title: s.sectionOwner,
              divider: false,
              child: AppFieldGrid(
                children: [
                  AppTextInput(
                    controlName: 'ownerName',
                    label: s.ownerName,
                    required: true,
                  ),
                  AppTextInput(
                    controlName: 'ownerPhone',
                    label: s.ownerPhone,
                    hint: '0912345678',
                    helper: s.ownerPhoneHelp,
                    kind: TextInputKind.phone,
                    required: true,
                    isLast: true,
                    onSubmitted: submit,
                  ),
                ],
              ),
            ),
            if (error != null) ...[
              const Gap(Space.lg),
              AppText(error, tone: TextTone.danger),
            ],
          ],
        ),
      ),
    );
  }
}
