import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import 'location_screen.dart';
import 'map_picker_view_model.dart';

/// Sets the place to browse from by moving the map under a pin, inside the
/// areas Kaziony works in. Closes with true once the place is kept.
class MapPickerScreen extends AppView {
  const MapPickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final value = ref.watch(mapPickerViewModel);
    final viewModel = ref.read(mapPickerViewModel.notifier);
    final data = value.value;

    Future<void> goToMyLocation() async {
      final problem = await viewModel.goToMyLocation();
      if (problem != null && context.mounted) {
        SSnack.error(context, problemMessage(s, problem));
      }
    }

    Future<void> confirm() async {
      if (await viewModel.confirm() && context.mounted) context.pop(true);
    }

    // Loading the areas, or failed to: a plain page that says so.
    if (data == null) {
      return SScaffold(
        title: s.mapTitle,
        body: SAsyncView(
          value: value,
          onRetry: () => ref.invalidate(mapPickerViewModel),
          builder: (_, _) => const SizedBox.shrink(),
        ),
      );
    }

    return SMapPage(
      onBack: () => context.pop(),
      map: SMapPicker(
        target: data.target,
        onMoved: viewModel.moved,
        areas: [
          for (final area in data.areas)
            SMapArea(center: area.center, radiusKm: area.radiusKm),
        ],
      ),
      action: SButton.secondary(
        label: s.myLocationButton,
        icon: SIcons.navigate,
        loading: data.locating,
        onPressed: goToMyLocation,
      ),
      panel: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SText.title(s.mapTitle),
          const Gap(Space.xs),
          SText(
            data.inside ? s.mapHint : outsideMessage(context, data.areas),
            color: data.inside ? SColor.textMuted : SColor.danger,
          ),
          const Gap(Space.lg),
          SButton(
            label: s.confirmPlace,
            expand: true,
            onPressed: data.inside ? confirm : null,
          ),
        ],
      ),
    );
  }
}
