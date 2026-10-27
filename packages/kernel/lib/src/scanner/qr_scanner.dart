import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// What the camera is doing, for the screen around it.
enum ScannerStatus {
  /// Opening the camera, or asking for it the first time.
  starting,
  scanning,

  /// The camera is turned off for the app in the phone's settings:
  /// [QrScanner.openSettings] takes the user there.
  denied,

  /// No camera, or it couldn't be opened.
  failed,
}

@immutable
class ScannerState {
  const ScannerState(this.status, {this.hasTorch = false});

  final ScannerStatus status;

  /// The phone has a light by the camera.
  final bool hasTorch;

  @override
  bool operator ==(Object other) =>
      other is ScannerState &&
      other.status == status &&
      other.hasTorch == hasTorch;

  @override
  int get hashCode => Object.hash(status, hasTorch);
}

/// Reads QR codes with the camera. Tests use a fake.
abstract interface class QrScanner {
  /// The camera's picture. [onCode] gets what each QR code holds, again and
  /// again while it stays in view; [onState] gets each change of the
  /// camera's state; [torch] turns the light on.
  ///
  /// The camera runs only while the view is on screen and the app is in
  /// front: it stops on another tab, under another page, and when the phone
  /// locks.
  Widget view({
    required ValueChanged<String> onCode,
    required ValueChanged<ScannerState> onState,
    bool torch = false,
  });

  /// Opens the app's page in the phone's settings, where the camera can be
  /// allowed again.
  Future<void> openSettings();
}

class DeviceQrScanner implements QrScanner {
  const DeviceQrScanner();

  @override
  Widget view({
    required ValueChanged<String> onCode,
    required ValueChanged<ScannerState> onState,
    bool torch = false,
  }) => _CameraView(onCode: onCode, onState: onState, torch: torch);

  @override
  Future<void> openSettings() => AppSettings.openAppSettings();
}

class _CameraView extends StatefulWidget {
  const _CameraView({
    required this.onCode,
    required this.onState,
    required this.torch,
  });

  final ValueChanged<String> onCode;
  final ValueChanged<ScannerState> onState;
  final bool torch;

  @override
  State<_CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<_CameraView> {
  final _camera = MobileScannerController(
    autoStart: false,
    formats: const [BarcodeFormat.qrCode],
  );
  late final AppLifecycleListener _lifecycle;
  late final StreamSubscription<BarcodeCapture> _codes;

  /// False on another tab or under another page.
  ValueListenable<TickerModeData>? _onScreen;
  bool _inFront = true;
  bool _running = false;
  bool _switchingTorch = false;
  ScannerState? _reported;

  /// Starts and stops one after the other: the camera refuses a start while
  /// it's still stopping.
  Future<void> _queue = Future.value();

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onStateChange: (state) {
        // Inactive is still in front: iOS's own camera prompt makes the
        // app inactive, and stopping then would close the camera it opens.
        _inFront =
            state == AppLifecycleState.resumed ||
            state == AppLifecycleState.inactive;
        // Back from the phone's settings, the camera may be allowed now.
        _sync();
      },
    );
    _codes = _camera.barcodes.listen(_read);
    _camera.addListener(_changed);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final onScreen = TickerMode.getValuesNotifier(context);
    if (onScreen != _onScreen) {
      _onScreen?.removeListener(_sync);
      _onScreen = onScreen..addListener(_sync);
      _sync();
    }
  }

  @override
  void didUpdateWidget(_CameraView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.torch != oldWidget.torch) _matchTorch();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _onScreen?.removeListener(_sync);
    _camera.removeListener(_changed);
    unawaited(_codes.cancel());
    unawaited(_camera.dispose());
    super.dispose();
  }

  void _sync() {
    final run = _inFront && (_onScreen?.value.enabled ?? false);
    if (run == _running) return;
    _running = run;
    _queue = _queue.then((_) async {
      if (!mounted) return;
      try {
        await (run ? _camera.start() : _camera.stop());
      } on MobileScannerException {
        // Shown through the camera's state, in _changed.
      }
    });
  }

  void _read(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.isNotEmpty) {
        widget.onCode(value);
        return;
      }
    }
  }

  void _changed() {
    final camera = _camera.value;
    final state = switch (camera.error?.errorCode) {
      MobileScannerErrorCode.permissionDenied => const ScannerState(
        ScannerStatus.denied,
      ),
      null when camera.isRunning => ScannerState(
        ScannerStatus.scanning,
        hasTorch: camera.torchState != TorchState.unavailable,
      ),
      null => const ScannerState(ScannerStatus.starting),
      _ => const ScannerState(ScannerStatus.failed),
    };
    if (state != _reported) {
      _reported = state;
      widget.onState(state);
    }
    _matchTorch();
  }

  /// The light goes off whenever the camera stops, so it's switched back
  /// on to match [_CameraView.torch] once the camera runs again.
  void _matchTorch() {
    final camera = _camera.value;
    final on = switch (camera.torchState) {
      TorchState.on => true,
      TorchState.off => false,
      TorchState.auto || TorchState.unavailable => null,
    };
    if (_switchingTorch || !camera.isRunning || on == null) return;
    if (on == widget.torch) return;
    _switchingTorch = true;
    unawaited(
      _camera.toggleTorch().whenComplete(() => _switchingTorch = false),
    );
  }

  @override
  Widget build(BuildContext context) => MobileScanner(
    controller: _camera,
    // The screen around it shows the camera's state.
    errorBuilder: (_, _) => const SizedBox.expand(),
    placeholderBuilder: (_) => const SizedBox.expand(),
  );
}

final qrScannerProvider = Provider<QrScanner>((ref) => const DeviceQrScanner());
