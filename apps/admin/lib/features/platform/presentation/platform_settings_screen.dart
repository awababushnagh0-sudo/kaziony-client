import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/providers/access.dart';
import '../../../core/record/record_screen.dart';
import 'platform_settings_form_view_model.dart';
import 'platform_settings_view_model.dart';
import 'service_areas_section.dart';

/// Settings for everyone using the apps, edited in place like a record.
class PlatformSettingsScreen extends AppView {
  const PlatformSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final isAdmin = ref.watch(isAdminProvider);
    return RecordScreen(
      record: platformSettingsViewModel,
      form: platformSettingsFormViewModel,
      title: (_) => s.platformSettingsTitle,
      builder: (context, _) => SRecordPage(
        tabs: [
          RecordTab(
            label: s.platformOffersSection,
            child: SFormSection(
              title: s.platformOffersSection,
              divider: false,
              child: SFieldGrid(
                columns: 3,
                children: [
                  STextInput(
                    controlName: 'browseRadiusKm',
                    label: s.browseRadiusLabel,
                    helper: isAdmin
                        ? s.browseRadiusHint(
                            minBrowseRadiusKm,
                            maxBrowseRadiusKm,
                          )
                        : s.browseRadiusEditorHint,
                    kind: TextInputKind.number,
                    required: true,
                  ),
                  STextInput(
                    controlName: 'holdMinutes',
                    label: s.holdMinutesLabel,
                    helper: isAdmin
                        ? s.holdMinutesHint(minHoldMinutes, maxHoldMinutes)
                        : s.holdMinutesEditorHint,
                    kind: TextInputKind.number,
                    required: true,
                  ),
                ],
              ),
            ),
          ),
          RecordTab(
            label: s.platformAreasSection,
            child: SFormSection(
              title: s.platformAreasSection,
              divider: false,
              child: const ServiceAreasSection(),
            ),
          ),
        ],
      ),
    );
  }
}
