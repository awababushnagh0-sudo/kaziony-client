import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../domain/store.dart';
import 'store_view_model.dart';

/// The store's branches. Our team adds them; editing opening hours comes
/// later.
class BranchesScreen extends AppView {
  const BranchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    return SScaffold(
      title: s.branchesTitle,
      body: SAsyncView(
        value: ref.watch(storeViewModel),
        onRetry: ref.read(storeViewModel.notifier).reload,
        builder: (context, store) => SingleChildScrollView(
          child: SListGroup(
            children: [
              for (final branch in store.branches)
                SListTile(
                  icon: SIcons.location,
                  title: branch.name,
                  subtitle: _place(s, branch),
                  trailing: branch.isActive ? null : SBadge(s.inactive),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// "Hay Al Andalus · Tripoli · 0912345678"
String _place(PartnerLocalizations s, Branch branch) => [
  branch.area,
  branch.address,
  switch (branch.city) {
    City.tripoli => s.cityTripoli,
    null => null,
  },
  if (branch.phone case final phone?) formatLibyanPhone(phone),
].whereType<String>().where((part) => part.isNotEmpty).join(' · ');
