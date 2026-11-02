import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/widgets/back_button.dart';
import '../../../core/widgets/customer_illustrations.dart';
import '../domain/browse_location.dart';
import 'location_problem.dart';
import 'location_view_model.dart';

/// Asks where to show offers from: where the phone is, or a place the
/// customer sets on the map ([mapRoute]). [onDone] runs once one is kept.
class LocationScreen extends AppView {
  const LocationScreen({
    required this.onDone,
    required this.mapRoute,
    this.canGoBack = false,
    super.key,
  });

  final VoidCallback onDone;
  final String mapRoute;

  /// Opened from the account page, not the welcome pages.
  final bool canGoBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final state = ref.watch(locationViewModel);
    final viewModel = ref.read(locationViewModel.notifier);

    Future<void> useMyLocation() async {
      if (await viewModel.useMyLocation()) onDone();
    }

    Future<void> setOnMap() async {
      if (await context.push<bool>(mapRoute) ?? false) onDone();
    }

    final message = switch (state) {
      LocationState(problem: final problem?) => problemMessage(s, problem),
      LocationState(outsideOf: final areas?) => outsideMessage(context, areas),
      LocationState(failure: final failure?) => failureMessage(
        context,
        failure,
      ),
      _ => null,
    };

    return SWelcomePage(
      top: [if (canGoBack) const CustomerBackButton()],
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
          SText.display(s.locationTitle, align: TextAlign.center),
          const Gap(Space.sm),
          SText(
            s.locationMessage,
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
