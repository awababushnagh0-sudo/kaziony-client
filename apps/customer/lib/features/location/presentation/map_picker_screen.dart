import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import 'location_screen.dart';
import 'map_picker_view_model.dart';
import 'place_details_sheet.dart';

/// Sets the place to browse from by moving the map under a pin, inside the
/// areas Kaziony works in, from [start] when given. Closes with the place
/// once it's confirmed.
///
/// [adding] a place to save: once the pin is set, a sheet asks for its
/// name and saves it on the account before the page closes.
class MapPickerScreen extends AppView {
  const MapPickerScreen({this.start, this.adding = false, super.key});

  final GeoPoint? start;
  final bool adding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final provider = mapPickerViewModel(start);
    final value = ref.watch(provider);
    final viewModel = ref.read(provider.notifier);
    final data = value.value;

    Future<void> goToMyLocation() async {
      final problem = await viewModel.goToMyLocation();
      if (problem != null && context.mounted) {
        SSnack.error(context, problemMessage(s, problem));
      }
    }

    Future<void> confirm() async {
      final point = viewModel.confirm();
      if (point == null) return;
      if (adding && !await PlaceDetailsSheet.add(context, point)) return;
      if (context.mounted) context.pop(point);
    }

    // Loading the areas, or failed to: a plain page that says so.
    if (data == null) {
      return SScaffold(
        title: s.mapTitle,
        body: SAsyncView(
          value: value,
          onRetry: () => ref.invalidate(provider),
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
