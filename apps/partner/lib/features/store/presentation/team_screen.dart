import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../domain/store.dart';
import 'store_view_model.dart';

/// Who works at the store. Our team adds and removes people.
class TeamScreen extends AppView {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    return SScaffold(
      title: s.teamTitle,
      body: SAsyncView(
        value: ref.watch(storeViewModel),
        onRetry: ref.read(storeViewModel.notifier).reload,
        builder: (context, store) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SListGroup(
                children: [
                  for (final member in store.members)
                    SListTile(
                      icon: SIcons.user,
                      title: member.name ?? s.notSet,
                      subtitle: _details(s, store, member),
                      trailing: member.isActive ? null : SBadge(s.inactive),
                    ),
                ],
              ),
              const Gap(Space.sm),
              SText.caption(s.teamHint),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Staff · Hay Al Andalus · 0912345678"
String _details(PartnerLocalizations s, Store store, StoreMember member) {
  final branchId = member.branchId;
  return [
    if (member.isOwner) s.ownerRole else s.staffRole,
    if (!member.isOwner)
      branchId == null
          ? s.allBranches
          : store.branches
                .where((branch) => branch.id == branchId)
                .firstOrNull
                ?.name,
    if (member.phone case final phone?) formatLibyanPhone(phone),
  ].whereType<String>().join(' · ');
}
