import 'package:flutter/widgets.dart';
import 'package:kernel/kernel.dart' show PhotoSource;

import '../../l10n/generated/stellar_localizations.dart';
import '../dialog/s_dialog.dart';
import '../sheet/s_sheet.dart';
import '../sheet/s_sheet_renderer.dart';

/// The questions around taking a photo, in every app's words.
abstract final class SPhoto {
  /// Camera or gallery, in a sheet. Null when it's closed.
  static Future<PhotoSource?> chooseSource(BuildContext context) {
    final s = StellarLocalizations.of(context);
    return SSheet.choose(
      context,
      title: s.photo,
      options: [
        SheetOption(value: PhotoSource.camera, label: s.takePhoto),
        SheetOption(value: PhotoSource.gallery, label: s.choosePhoto),
      ],
    );
  }

  /// The camera is turned off for the app: asks whether to open Settings.
  static Future<bool> askToOpenSettings(BuildContext context) {
    final s = StellarLocalizations.of(context);
    return SDialog.confirm(
      context,
      title: s.cameraOffTitle,
      message: s.cameraOffMessage,
      confirmLabel: s.openSettings,
    );
  }
}
