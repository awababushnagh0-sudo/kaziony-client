import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/widgets/back_button.dart';
import '../../../core/widgets/customer_illustrations.dart';
import '../domain/browse_location.dart';
import 'location_problem.dart';
import 'location_view_model.dart';

/// Why [LocationScreen] asks.
enum LocationPurpose {
  /// The welcome pages' first place.
  welcome,

  /// From the app, with no saved place to switch to. Once signed in, a
  /// spot set on the map is named and saved there.
  change,

  /// A place to save: where the phone is goes through the map too, which
  /// names the place and saves it.
  add,
}

/// Asks where to show offers from: where the phone is, or a place the
/// customer sets on the map ([mapRoute]). [onDone] runs once one is kept.
class LocationScreen extends AppView {
  const LocationScreen({
    required this.onDone,
    required this.mapRoute,
    this.purpose = LocationPurpose.welcome,
    super.key,
  });

  final VoidCallback onDone;
  final String mapRoute;
  final LocationPurpose purpose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final state = ref.watch(locationViewModel);
    final viewModel = ref.read(locationViewModel.notifier);
    final adding = purpose == LocationPurpose.add;
    // The map saved the spot and shows offers from it already.
    final mapSaves =
        adding ||
        (purpose == LocationPurpose.change &&
            ref.watch(sessionProvider) is SignedIn);

    Future<void> useMyLocation() async {
      final point = await viewModel.locate();
      if (point == null || !context.mounted) return;
      if (adding) {
        // To fine-tune the pin and name the place.
        if (await context.push<GeoPoint>(mapRoute, extra: point) == null) {
          return;
        }
      } else {
        await viewModel.use(point, pinned: false);
      }
      if (context.mounted) onDone();
    }

    Future<void> setOnMap() async {
      final point = await context.push<GeoPoint>(mapRoute);
      if (point == null || !context.mounted) return;
      if (!mapSaves) await viewModel.use(point, pinned: true);
      if (context.mounted) onDone();
    }

    final message = locationStateMessage(context, state);

    return SWelcomePage(
      top: [if (purpose != LocationPurpose.welcome) const CustomerBackButton()],
      actions: [
        SButton(
          label: s.useMyLocation,
          icon: SIcons.navigate,
          loading: state.finding,
          expand: true,
          onPressed: useMyLocation,
        ),
        SButton.secondary(label: s.setOnMap, expand: true, onPressed: setOnMap),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SIllustration(CustomerIllustrations.location),
          const Gap(Space.lg),
          SText.display(
            adding ? s.addPlaceTitle : s.locationTitle,
            align: TextAlign.center,
          ),
          const Gap(Space.sm),
          SText(
            adding ? s.addPlaceMessage : s.locationMessage,
            color: SColor.textMuted,
            align: TextAlign.center,
          ),
          if (message != null) ...[
            const Gap(Space.lg),
            SText(message, color: SColor.danger, align: TextAlign.center),
            if (state.problem?.needsSettings ?? false)
              Center(
                child: SButton.text(
                  label: StellarLocalizations.of(context).openSettings,
                  onPressed: viewModel.openSettings,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// Why the phone's location couldn't be used, if it couldn't.
String? locationStateMessage(BuildContext context, LocationState state) =>
    switch (state) {
      LocationState(problem: final problem?) => problemMessage(
        CustomerLocalizations.of(context),
        problem,
      ),
      LocationState(outsideOf: final areas?) => outsideMessage(context, areas),
      LocationState(failure: final failure?) => failureMessage(
        context,
        failure,
      ),
      _ => null,
    };

/// What to tell the customer about [problem].
String problemMessage(CustomerLocalizations s, LocationProblem problem) =>
    switch (problem) {
      LocationProblem.denied => s.locationDenied,
      LocationProblem.deniedForever => s.locationDeniedForever,
      LocationProblem.off => s.locationOff,
      LocationProblem.failed => s.locationFailed,
    };

/// "Kaziony is only in Tripoli for now."
String outsideMessage(BuildContext context, List<ServiceArea> areas) {
  final s = CustomerLocalizations.of(context);
  final language = Localizations.localeOf(context).languageCode;
  return s.outsideServiceArea(
    areas.map((area) => area.name(language)).join(s.listSeparator),
  );
}
