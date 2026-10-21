import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/business_localizations.dart';
import '../../../core/widgets/language_button.dart';
import '../../auth/domain/auth_repository.dart';
import 'home_view_model.dart';

/// Placeholder home: the merchant's store and branches.
/// Products, offers and the counter come in the next steps.
class HomeScreen extends AppView {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = BusinessLocalizations.of(context);
    final home = ref.watch(homeViewModel);
    final logout = SButton.text(
      label: s.logout,
      icon: SIcons.logout,
      onPressed: () => ref.read(authRepositoryProvider).logout(),
    );

    return SScaffold(
      title: home.value?.store.name ?? s.appTitle,
      actions: [const LanguageButton(), logout],
      padded: false,
      body: SAsyncView(
        value: home,
        onRetry: ref.read(homeViewModel.notifier).reload,
        builder: (context, data) => data == null
            ? SEmptyView(
                title: s.noStoreTitle,
                message: s.noStoreMessage,
                icon: SIcons.store,
              )
            : _StoreView(data: data),
      ),
    );
  }
}

class _StoreView extends StatelessWidget {
  const _StoreView({required this.data});

  final HomeData data;

  @override
  Widget build(BuildContext context) {
    final s = BusinessLocalizations.of(context);
    final store = data.store;
    return ListView(
      padding: const EdgeInsets.all(Space.xl),
      children: [
        SCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SText.title(store.name),
              const Gap(Space.xs),
              SText(
                data.membership.isOwner ? s.ownerRole : s.staffRole,
                color: SColor.textMuted,
              ),
              const Gap(Space.md),
              SText(
                store.isActive ? s.storeActive : s.storeDisabled,
                color: store.isActive ? SColor.success : SColor.danger,
                weight: SFontWeight.bold,
              ),
              if (store.description != null) ...[
                const Gap(Space.md),
                SText(store.description!),
              ],
            ],
          ),
        ),
        const Gap(Space.xl),
        SText.title(s.branchesTitle),
        const Gap(Space.sm),
        SCard(
          padded: false,
          child: Column(
            children: [
              for (final branch in store.branches)
                SListTile(
                  icon: SIcons.location,
                  title: branch.name,
                  subtitle: [
                    branch.area,
                    if (branch.city case final city?) _cityName(s, city),
                  ].nonNulls.join('، '),
                  trailing: branch.isActive
                      ? null
                      : SText.caption(s.branchClosed, color: SColor.danger),
                ),
            ],
          ),
        ),
        const Gap(Space.xxl),
        SText(s.comingNext, color: SColor.textMuted, align: TextAlign.center),
      ],
    );
  }
}

String _cityName(BusinessLocalizations s, City city) => switch (city) {
  City.tripoli => s.cityTripoli,
};
