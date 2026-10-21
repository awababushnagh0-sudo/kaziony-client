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

    final point = state.location;

    final error = switch (state) {
      AddStoreState(problem: AddStoreProblem.phoneTakenByCustomer) =>
        s.phoneTakenByCustomer,
      AddStoreState(:final failure?) => failureMessage(context, failure),
      _ => null,
    };

    return SDialog(
      title: s.addStoreTitle,
      width: 640,
      primaryLabel: s.createStore,
      onPrimary: submit,
      busy: state.submitting,
      body: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SFormSection(
              title: s.sectionStore,
              child: SFieldGrid(
                children: [
                  STextInput(
                    controlName: 'name',
                    label: s.storeName,
                    required: true,
                    autofocus: true,
                  ),
                  switch (categories) {
                    AsyncError() => SText(
                      s.categoriesFailed,
                      color: SColor.danger,
                    ),
                    _ => SSelectInput<String>(
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
                  STextInput(
                    controlName: 'phone',
                    label: s.storePhone,
                    hint: '0912345678',
                    kind: TextInputKind.phone,
                  ),
                  STextInput(
                    controlName: 'email',
                    label: s.storeEmail,
                    kind: TextInputKind.email,
                  ),
                ],
              ),
            ),
            SFormSection(
              title: s.sectionBranch,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SFieldGrid(
                    children: [
                      STextInput(
                        controlName: 'branchName',
                        label: s.branchName,
                        hint: s.branchNameHint,
                        required: true,
                      ),
                      SSelectInput<City>(
                        controlName: 'city',
                        label: s.branchCity,
                        required: true,
                        options: [
                          for (final city in City.values)
                            SelectOption(city, _cityName(s, city)),
                        ],
                      ),
                      STextInput(controlName: 'area', label: s.branchArea),
                      STextInput(
                        controlName: 'address',
                        label: s.branchAddress,
                      ),
                    ],
                  ),
                  const Gap(Space.lg),
                  STextInput(
                    controlName: 'location',
                    label: s.branchLocation,
                    hint: 'https://maps.google.com/...',
                    helper: point == null
                        ? s.branchLocationHelp
                        : s.locationFound(
                            point.latitude.toStringAsFixed(5),
                            point.longitude.toStringAsFixed(5),
                          ),
                    kind: TextInputKind.url,
                    required: true,
                    validationMessages: {
                      LocationErrors.unreadable: (_) => s.invalidLocation,
                      LocationErrors.outsideLibya: (_) =>
                          s.locationOutsideLibya,
                      LocationErrors.unchecked: (_) => s.locationUnchecked,
                    },
                  ),
                ],
              ),
            ),
            SFormSection(
              title: s.sectionOwner,
              divider: false,
              child: SFieldGrid(
                children: [
                  STextInput(
                    controlName: 'ownerName',
                    label: s.ownerName,
                    required: true,
                  ),
                  STextInput(
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
              SText(error, color: SColor.danger),
            ],
          ],
        ),
      ),
    );
  }
}

String _cityName(AdminLocalizations s, City city) => switch (city) {
  City.tripoli => s.cityTripoli,
};
