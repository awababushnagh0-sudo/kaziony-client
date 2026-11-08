import 'dart:async';

import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/offer_split_bar.dart';
import '../../store/domain/current_store.dart';
import '../../store/domain/store.dart';
import '../../store/presentation/store_view_model.dart';
import '../domain/offer.dart';
import 'offer_view_model.dart';
import 'widgets/offer_labels.dart';

/// One offer, laid out like the customer's page of it: its photo with its
/// name and price on it, when it ends and how many are left, where its
/// pieces are now, then its details. The owner's everyday actions are at
/// the bottom; posting it again and ending it, rarer, are in the menu.
class OfferScreen extends AppView {
  const OfferScreen({required this.offerId, super.key});

  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offer = ref.watch(offerViewModel(offerId));
    final isOwner = ref.watch(currentStoreProvider)?.isOwner ?? false;
    final shown = offer.value;
    return SScaffold(
      // Loaded, the page opens on the offer's photo, whose bar stays pinned
      // with the back button; loading or failing, it keeps the app bar's.
      showAppBar: shown == null,
      underStatusBar: shown != null,
      padded: shown == null,
      bottom: isOwner && shown != null ? _Actions(offer: shown) : null,
      body: SAsyncView(
        value: offer,
        onRetry: () => ref.invalidate(offerViewModel(offerId)),
        loading: const _Skeleton(),
        builder: (context, offer) => CustomScrollView(
          slivers: [
            _Header(offer: offer, isOwner: isOwner),
            SliverToBoxAdapter(child: _Body(offer: offer)),
          ],
        ),
      ),
    );
  }
}

/// The page while the offer loads: its photo, the two boxes, then the bar
/// and the details.
class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) => const SSkeleton(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.md,
      children: [
        SBone.wide(),
        Row(
          spacing: Space.md,
          children: [
            Expanded(child: SBone.button()),
            Expanded(child: SBone.button()),
          ],
        ),
        Gap(Space.sm),
        SBone.text(variant: TextVariant.subtitle, length: BoneLength.short),
        SBone.button(),
        Gap(Space.sm),
        SBone.text(variant: TextVariant.subtitle, length: BoneLength.short),
        SBone.text(length: BoneLength.long),
        SBone.text(length: BoneLength.medium),
      ],
    ),
  );
}

class _Header extends AppView {
  const _Header({required this.offer, required this.isOwner});

  final Offer offer;
  final bool isOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final status = offerStatus(s, offer.state);
    return SPhotoHeader(
      title: offer.title,
      subtitle: formatPrice(offer.offerPrice, languageCode: language),
      trailing: status == null ? null : SBadge(status.label, tone: status.tone),
      imageUrl: offer.imageUrl,
      caption: _Caption(offer: offer),
      onBack: context.pop,
      // Once it's over, posting it again is the page's main button.
      action: isOwner && offer.canChange
          ? PhotoHeaderAction(
              icon: SIcons.more,
              tooltip: s.moreActions,
              onPressed: () => _more(context, ref),
            )
          : null,
    );
  }

  Future<void> _more(BuildContext context, WidgetRef ref) async {
    final s = PartnerLocalizations.of(context);
    final picked = await SSheet.actions<_More>(
      context,
      title: offer.title,
      actions: [
        SheetAction(
          value: _More.repost,
          icon: SIcons.repost,
          label: s.repostOffer,
          hint: s.repostOfferHint,
        ),
        SheetAction(
          value: _More.end,
          icon: SIcons.stop,
          label: s.endOffer,
          hint: s.endOfferHint,
        ),
      ],
    );
    if (!context.mounted) return;
    switch (picked) {
      case _More.repost:
        unawaited(
          context.push(Routes.newOffer(offer.productId, from: offer.id)),
        );
      case _More.end:
        // Ending is for good, so it asks first.
        final confirmed = await SDialog.confirm(
          context,
          title: s.endOfferTitle,
          message: s.endOfferMessage,
          confirmLabel: s.endOffer,
          destructive: true,
        );
        if (confirmed && context.mounted) {
          await _run(
            context,
            ref.read(offerViewModel(offer.id).notifier).end(),
            s.offerEndedDone,
          );
        }
      case null:
        break;
    }
  }
}

enum _More { repost, end }

/// On the photo's foot, in white over its shade: what customers see of it
/// now, its name, and its price beside the regular one.
class _Caption extends StatelessWidget {
  const _Caption({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final status = offerStatus(s, offer.state);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      spacing: Space.xs,
      children: [
        if (status != null) SBadge.status(status.label, tone: status.tone),
        SText.display(offer.title, color: SColor.onScrim),
        Wrap(
          spacing: Space.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SText(
              formatPrice(offer.offerPrice, languageCode: language),
              variant: TextVariant.title,
              weight: SFontWeight.bold,
              color: SColor.onScrimBrand,
            ),
            SText(
              formatPrice(offer.originalPrice, languageCode: language),
              color: SColor.onScrim,
              struck: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _Body extends AppView {
  const _Body({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final claims = offer.claims;
    final total = offer.totalQuantity;
    final branches = ref.watch(storeViewModel).value?.branches;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Space.lg, Space.lg, Space.lg, 0),
          child: SFactBoxes([_when(context), _second(s)]),
        ),
        _Section(
          title: s.offerPiecesTitle,
          child: SCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: Space.sm,
              children: [
                OfferSplitBar(offer),
                // Pieces that came back on sale: no longer in the bar.
                if (offer.state != OfferState.scheduled)
                  SText.caption(
                    s.notPickedUpOrCancelled(claims.expired, claims.cancelled),
                  ),
              ],
            ),
          ),
        ),
        _Section(
          title: s.offerDetailsTitle,
          child: SListGroup(
            children: [
              // Without a limit, how many saw it is in the box above.
              if (total != null) ...[
                SFactTile(label: s.seenLabel, value: '${offer.viewCount}'),
                SFactTile(
                  label: s.holdTitle,
                  value: s.holdValue(offer.claimWindowMinutes),
                ),
              ],
              SFactTile(
                label: s.perCustomerLabel,
                value: offer.maxPerUser?.toString() ?? s.noLimit,
              ),
              SFactTile(label: s.branchesTitle, value: _branches(s, branches)),
            ],
          ),
        ),
        const Gap(Space.xl),
      ],
    );
  }

  /// When it starts, until when it runs, or when it ended.
  FactBox _when(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    String at(DateTime time) => s.dayAndTime(
      isSameDay(time, DateTime.now())
          ? s.dayToday
          : formatDayMonth(time, languageCode: language),
      formatTime(time, languageCode: language),
    );
    return switch (offer.state) {
      OfferState.scheduled => FactBox(
        icon: SIcons.clock,
        label: s.startsLabel,
        value: at(offer.startsAt),
      ),
      OfferState.ended || OfferState.removed => FactBox(
        icon: SIcons.clock,
        label: s.offerEnded,
        value: at(offer.endsAt),
      ),
      _ => FactBox(
        icon: SIcons.clock,
        label: s.endsLabel,
        value: at(offer.endsAt),
      ),
    };
  }

  /// How many are left of a limited offer; how many saw one without a
  /// limit, which has nothing to run out of.
  FactBox _second(PartnerLocalizations s) {
    final total = offer.totalQuantity;
    if (total == null) {
      return FactBox(
        icon: SIcons.show,
        label: s.seenLabel,
        value: '${offer.viewCount}',
      );
    }
    return FactBox(
      icon: SIcons.products,
      label: offer.state == OfferState.scheduled ? s.figureReady : s.figureLeft,
      value: s.leftOfTotal(offer.remainingQuantity ?? 0, total),
      hot: offer.state == OfferState.live && offer.isRunningOut,
    );
  }

  /// The branch by name when it's one, "All branches" when it's every one
  /// that's open; otherwise, or before the store has loaded, how many.
  String _branches(PartnerLocalizations s, List<Branch>? all) {
    final ids = offer.branchIds;
    if (all != null) {
      final names = [
        for (final branch in all)
          if (ids.contains(branch.id)) branch.name,
      ];
      if (names.length == 1 && ids.length == 1) return names.single;
      final open = all.where((branch) => branch.isActive);
      if (open.length > 1 && open.every((branch) => ids.contains(branch.id))) {
        return s.allBranches;
      }
    }
    return s.branchCount(ids.length);
  }
}

/// A part of the page under its title.
class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(Space.lg, Space.xl, Space.lg, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: Space.sm,
      children: [SSectionHeader(title), child],
    ),
  );
}

/// Shows what an owner's action did, or what went wrong.
Future<void> _run(
  BuildContext context,
  Future<AppFailure?> action,
  String done,
) async {
  final failure = await action;
  if (!context.mounted) return;
  if (failure == null) {
    SSnack.success(context, done);
  } else {
    SSnack.error(context, failureMessage(context, failure));
  }
}

/// Pause or resume, and edit; or post it again once it's over. One is
/// green: resuming a paused offer, or else editing; pausing hides it from
/// customers, so it's never the one that stands out.
class _Actions extends AppView {
  const _Actions({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final viewModel = ref.read(offerViewModel(offer.id).notifier);
    void edit() => context.push(Routes.editOffer(offer.id));
    if (!offer.canChange) {
      return SButton(
        label: s.repostOffer,
        icon: SIcons.repost,
        expand: true,
        onPressed: () =>
            context.push(Routes.newOffer(offer.productId, from: offer.id)),
      );
    }
    return Row(
      spacing: Space.md,
      children: [
        Expanded(
          child: offer.canResume
              ? SButton(
                  label: s.resumeOffer,
                  icon: SIcons.resume,
                  expand: true,
                  onPressed: () =>
                      _run(context, viewModel.resume(), s.offerResumed),
                )
              : SButton.soft(
                  label: s.pauseOffer,
                  icon: SIcons.pause,
                  expand: true,
                  onPressed: () =>
                      _run(context, viewModel.pause(), s.offerPausedDone),
                ),
        ),
        Expanded(
          child: offer.canResume
              ? SButton.soft(
                  label: s.edit,
                  icon: SIcons.edit,
                  expand: true,
                  onPressed: edit,
                )
              : SButton(
                  label: s.edit,
                  icon: SIcons.edit,
                  expand: true,
                  onPressed: edit,
                ),
        ),
      ],
    );
  }
}
