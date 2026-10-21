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
    final logout = AppButton.text(
      label: s.logout,
      icon: AppIcon.logout,
      onPressed: () => ref.read(authRepositoryProvider).logout(),
    );

    return AppScaffold(
      title: home.value?.store.name ?? s.appTitle,
      actions: [const LanguageButton(), logout],
      padded: false,
      body: AppAsyncView(
        value: home,
        onRetry: ref.read(homeViewModel.notifier).reload,
        builder: (context, data) => data == null
            ? AppEmptyView(
                title: s.noStoreTitle,
                message: s.noStoreMessage,
                icon: AppIcon.store,
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
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.title(store.name),
              const Gap(Space.xs),
              AppText(
                data.membership.isOwner ? s.ownerRole : s.staffRole,
                tone: TextTone.muted,
              ),
              const Gap(Space.md),
              AppText(
                store.isActive ? s.storeActive : s.storeDisabled,
                tone: store.isActive ? TextTone.success : TextTone.danger,
                bold: true,
              ),
              if (store.description != null) ...[
                const Gap(Space.md),
                AppText(store.description!),
              ],
            ],
          ),
        ),
        const Gap(Space.xl),
        AppText.title(s.branchesTitle),
        const Gap(Space.sm),
        AppCard(
          padded: false,
          child: Column(
            children: [
              for (final branch in store.branches)
                AppListTile(
                  icon: AppIcon.location,
                  title: branch.name,
                  subtitle: [branch.area, branch.city].nonNulls.join('، '),
                  trailing: branch.isActive
                      ? null
                      : AppText.caption(s.branchClosed, tone: TextTone.danger),
                ),
            ],
          ),
        ),
        const Gap(Space.xxl),
        AppText(s.comingNext, tone: TextTone.muted, align: TextAlign.center),
      ],
    );
  }
}
