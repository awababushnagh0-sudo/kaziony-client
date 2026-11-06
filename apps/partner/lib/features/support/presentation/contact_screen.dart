import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/widgets/partner_illustrations.dart';

/// How to reach our team: a forgotten password, a store to add, or help.
/// Opens signed in or out.
class ContactScreen extends AppView {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    Future<void> open(Uri link) async {
      final opened = await ref.read(linkOpenerProvider).open(link);
      if (!opened && context.mounted) SSnack.error(context, s.linkNotOpened);
    }

    return SScaffold(
      title: s.contactUs,
      body: SAsyncView(
        value: ref.watch(supportContactProvider),
        onRetry: () => ref.invalidate(supportContactProvider),
        loading: const SSkeleton.groups(),
        builder: (context, support) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(Space.lg),
              const Center(child: SIllustration(PartnerIllustrations.contact)),
              const Gap(Space.md),
              SText(
                s.contactMessage,
                color: SColor.textMuted,
                align: TextAlign.center,
              ),
              const Gap(Space.xl),
              SListGroup(
                separated: true,
                children: [
                  SListTile(
                    icon: SIcons.phone,
                    title: s.callUs,
                    subtitle: formatLibyanPhone(support.phone),
                    onTap: () => open(support.callLink),
                  ),
                  SListTile(
                    icon: SIcons.chat,
                    title: s.whatsappUs,
                    subtitle: formatLibyanPhone('+${support.whatsapp}'),
                    onTap: () => open(support.whatsappLink),
                  ),
                  SListTile(
                    icon: SIcons.mail,
                    title: s.emailLabel,
                    subtitle: support.email,
                    onTap: () => open(support.emailLink),
                  ),
                ],
              ),
              const Gap(Space.xl),
              SListGroup(
                children: [
                  SListTile(
                    icon: SIcons.clock,
                    title: s.supportHours,
                    subtitle: support.hoursIn(Localizations.localeOf(context)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
