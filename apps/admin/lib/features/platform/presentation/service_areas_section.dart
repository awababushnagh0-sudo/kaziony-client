import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/admin_localizations.dart';
import '../../../core/providers/access.dart';
import '../domain/service_area.dart';
import 'service_area_dialog.dart';
import 'service_areas_view_model.dart';

/// The areas Kaziony works in. Admins add and change them; editors read.
class ServiceAreasSection extends AppView {
  const ServiceAreasSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AdminLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final isAdmin = ref.watch(isAdminProvider);

    void open([ServiceArea? area]) => SDialog.show<void>(
      context,
      (_) => ServiceAreaDialog(area: area),
      dismissible: false,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: SText(s.serviceAreasHelp, color: SColor.textMuted)),
            if (isAdmin)
              SButton(
                label: s.addServiceArea,
                icon: SIcons.add,
                onPressed: open,
              ),
          ],
        ),
        const Gap(Space.lg),
        SAsyncView(
          value: ref.watch(serviceAreasViewModel),
          onRetry: () => ref.invalidate(serviceAreasViewModel),
          // The table is made of slivers; the record page scrolls, not it.
          builder: (context, areas) => CustomScrollView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              STable<ServiceArea>(
                rows: areas,
                totalLabel: s.serviceAreasTotal(areas.length),
                onOpen: isAdmin ? open : null,
                columns: [
                  TableColumn(
                    label: s.columnName,
                    cell: (area) =>
                        SCellText(area.name(language), strong: true),
                  ),
                  TableColumn(
                    label: s.serviceAreaCenter,
                    minWidth: 560,
                    cell: (area) => SCellText(
                      '${area.latitude}, ${area.longitude}',
                      ltr: true,
                    ),
                  ),
                  TableColumn(
                    label: s.serviceAreaRadius,
                    flex: 1,
                    cell: (area) => SCellText('${area.radiusKm}', ltr: true),
                  ),
                  TableColumn(
                    label: s.columnStatus,
                    flex: 1,
                    cell: (area) => Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: area.isActive
                          ? SBadge(s.serviceAreaOn, tone: BadgeTone.success)
                          : SBadge(s.serviceAreaOff),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
