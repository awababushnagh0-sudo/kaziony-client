import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';

/// What the app is, its version, and its terms.
class AboutScreen extends AppView {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final app = ref.watch(appInfoProvider);
    return SScaffold(
      title: s.aboutTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(Space.lg),
            const SIllustration(SIllustrations.partnerMark),
            const Gap(Space.lg),
            SText(
              s.aboutText,
              color: SColor.textMuted,
              align: TextAlign.center,
            ),
            const Gap(Space.xl),
            SListGroup(
              separated: true,
              children: [
                SListTile(
                  icon: SIcons.device,
                  title: s.versionLabel,
                  value: '${app.version} (${app.buildNumber})',
                ),
                SListTile(
                  icon: SIcons.document,
                  title: s.termsTitle,
                  onTap: () => context.push(Routes.terms),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
