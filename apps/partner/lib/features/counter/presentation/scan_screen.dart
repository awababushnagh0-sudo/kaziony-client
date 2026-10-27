import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/claim.dart';
import 'counter_branch_view_model.dart';
import 'widgets/counter_branch_sheet.dart';

/// The Scan tab: the camera opens right away, reading the customer's code;
/// the code can also be typed.
class ScanScreen extends AppStatefulView {
  const ScanScreen({super.key});

  @override
  AppViewState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends AppViewState<ScanScreen> {
  /// The code just handled stays in front of the camera for a moment after
  /// coming back (the customer is still holding it up): it isn't opened
  /// again before this.
  static const _sameCodeAgain = Duration(seconds: 5);

  var _camera = const ScannerState(ScannerStatus.starting);
  var _torch = false;

  /// A page is open over the camera, or opening: codes wait.
  var _away = false;
  String? _lastCode;
  DateTime? _backAt;

  /// The last QR code that wasn't a reservation, so it's said once.
  String? _lastWrong;

  Future<void> _read(String raw) async {
    if (_away) return;
    final code = ClaimCode.read(raw);
    if (code == null) {
      if (raw != _lastWrong) {
        _lastWrong = raw;
        SSnack.error(context, PartnerLocalizations.of(context).notAClaimCode);
      }
      return;
    }
    final backAt = _backAt;
    if (code == _lastCode &&
        backAt != null &&
        DateTime.now().difference(backAt) < _sameCodeAgain) {
      return;
    }
    _lastCode = code;
    await _open(Routes.claim(code));
  }

  Future<void> _open(String location) async {
    _away = true;
    await context.push(location);
    _away = false;
    _backAt = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final stellar = StellarLocalizations.of(context);
    final scanner = ref.watch(qrScannerProvider);
    final branches = ref.watch(counterBranchesProvider);
    return SScaffold(
      title: s.scanTitle,
      padded: false,
      actions: [
        SButton.icon(
          icon: SIcons.pickups,
          tooltip: s.pickupsTitle,
          onPressed: () => _open(Routes.pickups),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (branches.choices.isNotEmpty)
            SListTile(
              icon: SIcons.store,
              title: s.counterBranch,
              value: branches.current?.name ?? s.chooseValue,
              onTap: () => chooseCounterBranch(context, ref, branches),
            ),
          Expanded(
            child: SScannerView(
              camera: scanner.view(
                onCode: _read,
                onState: (state) => setState(() => _camera = state),
                torch: _torch,
              ),
              hint: s.scanHint,
              starting: _camera.status == ScannerStatus.starting,
              torchOn: _torch,
              onTorch: _camera.hasTorch
                  ? () => setState(() => _torch = !_torch)
                  : null,
              cover: switch (_camera.status) {
                ScannerStatus.denied => SEmptyView(
                  icon: SIcons.camera,
                  title: stellar.cameraOffTitle,
                  message: s.cameraOffScanMessage,
                  actionLabel: stellar.openSettings,
                  actionIcon: SIcons.settings,
                  onAction: scanner.openSettings,
                ),
                ScannerStatus.failed => SEmptyView(
                  icon: SIcons.camera,
                  title: s.cameraFailedTitle,
                  message: s.cameraFailedMessage,
                ),
                ScannerStatus.starting || ScannerStatus.scanning => null,
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: SButton.secondary(
              label: s.typeCode,
              icon: SIcons.keyboard,
              expand: true,
              onPressed: () => _open(Routes.typeCode),
            ),
          ),
        ],
      ),
    );
  }
}
