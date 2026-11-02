import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/service_area.dart';
import 'service_area_dialog_view_model.dart';

/// Adds a service area, or changes or deletes [area]. Pops once done.
class ServiceAreaDialog extends AppView {
  const ServiceAreaDialog({this.area, super.key});

  final ServiceArea? area;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final area = this.area;
    final provider = serviceAreaDialogViewModel(area);
    final state = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);

    Future<void> save() async {
      if (await viewModel.save() && context.mounted) Navigator.pop(context);
    }

    Future<void> delete() async {
      final language = Localizations.localeOf(context).languageCode;
      final confirmed = await SDialog.confirm(
        context,
        title: s.deleteServiceAreaTitle(area!.name(language)),
        message: s.deleteServiceAreaMessage,
        confirmLabel: s.deleteServiceArea,
        destructive: true,
      );
      if (confirmed && await viewModel.delete() && context.mounted) {
        Navigator.pop(context);
      }
    }

    final failure = state.failure;
    return SDialog(
      title: area == null ? s.addServiceAreaTitle : s.editServiceAreaTitle,
      width: 480,
      primaryLabel: area == null ? s.addServiceArea : s.save,
      onPrimary: save,
      busy: state.saving,
      body: SForm(
        form: viewModel.form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            STextInput(
              controlName: 'nameAr',
              label: s.serviceAreaNameAr,
              required: true,
              autofocus: area == null,
            ),
            const Gap(Space.lg),
            STextInput(
              controlName: 'nameEn',
              label: s.serviceAreaNameEn,
              required: true,
            ),
            const Gap(Space.lg),
            STextInput(
              controlName: 'center',
              label: s.serviceAreaCenter,
              hint: '32.85, 13.18',
              helper: s.serviceAreaCenterHelp,
              required: true,
              validationMessages: {
                coordinatesError: (_) => s.invalidCoordinates,
              },
            ),
            const Gap(Space.lg),
            STextInput(
              controlName: 'radiusKm',
              label: s.serviceAreaRadius,
              helper: s.serviceAreaRadiusHint(
                minServiceAreaRadiusKm,
                maxServiceAreaRadiusKm,
              ),
              kind: TextInputKind.number,
              required: true,
            ),
            const Gap(Space.lg),
            SSelectInput<bool>(
              controlName: 'isActive',
              label: s.columnStatus,
              required: true,
              options: [
                SelectOption(true, s.serviceAreaOn),
                SelectOption(false, s.serviceAreaOff),
              ],
            ),
            if (failure != null) ...[
              const Gap(Space.lg),
              SText(failureMessage(context, failure), color: SColor.danger),
            ],
            if (area != null) ...[
              const Gap(Space.xl),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: SButton.dangerSoft(
                  label: s.deleteServiceArea,
                  icon: SIcons.delete,
                  loading: state.deleting,
                  onPressed: delete,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
