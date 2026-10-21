import 'package:flutter/widgets.dart';

import '../../foundation/s_kit.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../icon/s_icon.dart';
import 's_status_renderer.dart';

/// Full-screen "please update" shown when this version is too old.
class SUpdateRequiredView extends StatelessWidget {
  const SUpdateRequiredView({super.key});

  @override
  Widget build(BuildContext context) {
    final s = StellarLocalizations.of(context);
    return StellarKit.of(context).status.empty(
      context,
      StatusSpec(
        title: s.updateRequiredTitle,
        message: s.updateRequiredMessage,
        icon: SIcons.update,
      ),
    );
  }
}
