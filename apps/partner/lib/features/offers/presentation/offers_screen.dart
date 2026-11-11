import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/offer_card.dart';
import '../../../core/widgets/offer_card_skeleton.dart';
import '../../../core/widgets/partner_illustrations.dart';
import '../../store/domain/current_store.dart';
import '../../store/presentation/store_view_model.dart';
import '../domain/offer.dart';
import 'offers_view_model.dart';
import 'widgets/offer_labels.dart';
import 'widgets/start_offer.dart';

/// The Offers tab: everyone in the store sees the offers; owners post them.
/// The current ones come in groups (on now, coming up, paused), the
/// finished ones apart.
class OffersScreen extends AppView {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final ended = ref.watch(showEndedOffersProvider);
    final offers = ref.watch(offersViewModel);
    final isOwner = ref.watch(currentStoreProvider)?.isOwner ?? false;
    final live = ref.watch(storeIsLiveProvider);
    // Not while loading: the empty list kept from the ended ones isn't the
    // current one.
    final firstEmpty =
        !ended && !offers.isLoading && (offers.value?.items.isEmpty ?? false);
    return SScaffold(
      title: s.offersTitle,
      // The cards keep their own sides; the choice keeps the usual ones.
      padded: false,
      // In the bar, as on Products. The empty list has its own button to
      // post one.
      actions: [
        if (isOwner && !firstEmpty)
          SButton.text(
            label: s.postOffer,
            icon: SIcons.add,
            onPressed: live ? () => startOffer(context) : null,
          ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            // The list below brings its own room above the cards.
            padding: const EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, 0),
            child: SSegmented<bool>.labels(
              options: [
                SelectOption(false, s.activeOffers),
                SelectOption(true, s.endedOffers),
              ],
              selected: ended,
              onChanged: (ended) =>
                  ref.read(showEndedOffersProvider.notifier).show(ended: ended),
            ),
          ),
          Expanded(
            child: _OfferList(ended: ended, isOwner: isOwner),
          ),
        ],
      ),
    );
  }
}

/// The groups the current offers come in, in the order the backend sends
/// them.
enum _Group {
  now,
  later,
  paused;

  static _Group of(Offer offer) => offer.status == OfferStatus.paused
      ? paused
      : offer.state == OfferState.scheduled
      ? later
      : now;

  String title(PartnerLocalizations s) => switch (this) {
    now => s.liveNowSection,
    later => s.comingUpSection,
    paused => s.pausedSection,
  };
}

class _OfferList extends AppView {
  const _OfferList({required this.ended, required this.isOwner});

  final bool ended;
  final bool isOwner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final viewModel = ref.read(offersViewModel.notifier);
    final live = ref.watch(storeIsLiveProvider);
    // Said from the list, which stays: the card moves to its new group.
    Future<void> resume(Offer offer) async {
      final failure = await viewModel.resume(offer.id);
      if (!context.mounted) return;
      if (failure == null) {
        SSnack.success(context, s.offerResumed);
      } else {
        SSnack.error(context, offerFailureMessage(context, failure));
      }
    }

    return SAsyncView(
      value: ref.watch(offersViewModel),
      onRetry: () => ref.invalidate(offersViewModel),
      loading: const OfferListSkeleton(),
      builder: (context, page) {
        if (page.items.isEmpty) {
          if (ended) {
            return SEmptyView(
              illustration: PartnerIllustrations.noOffersHere,
              title: s.noOffersHere,
            );
          }
          return SEmptyView(
            illustration: PartnerIllustrations.noOffers,
            title: s.noOffersTitle,
            message: !isOwner
                ? null
                : live
                ? s.noOffersMessage
                : s.storeNotLiveCantPost,
            actionLabel: isOwner && live ? s.postOffer : null,
            onAction: () => startOffer(context),
          );
        }
        return SPagedList(
          // The offers are cards, apart from each other.
          divided: false,
          itemCount: page.items.length,
          itemBuilder: (context, index) {
            final offer = page.items[index];
            final card = OfferCard(
              offer: offer,
              onTap: () => context.push(Routes.offer(offer.id)),
              action: isOwner && offer.canResume
                  ? _ResumeButton(onPressed: live ? () => resume(offer) : null)
                  : null,
            );
            final group = _Group.of(offer);
            final heads =
                !ended &&
                (index == 0 || _Group.of(page.items[index - 1]) != group);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: heads
                  ? Padding(
                      // More room above a group than between its cards.
                      padding: EdgeInsets.only(top: index == 0 ? 0 : Space.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: Space.sm,
                        children: [SSectionHeader(group.title(s)), card],
                      ),
                    )
                  : card,
            );
          },
          onRefresh: () async {
            final failure = await viewModel.refresh();
            if (failure != null && context.mounted) {
              SSnack.error(context, failureMessage(context, failure));
            }
          },
          onLoadMore: viewModel.loadMore,
          hasMore: page.hasMore,
          loadingMore: page.loadingMore,
          moreFailure: page.moreFailure,
          placeholder: const Padding(
            padding: EdgeInsets.fromLTRB(Space.lg, Space.sm, Space.lg, 0),
            child: OfferCardSkeleton(),
          ),
        );
      },
    );
  }
}

/// Resumes a paused offer from its card, without opening it: the one thing
/// to do about a paused offer. Busy until [onPressed] is done.
class _ResumeButton extends AppStatefulView {
  const _ResumeButton({required this.onPressed});

  /// Null while the store is off.
  final Future<void> Function()? onPressed;

  @override
  AppViewState<_ResumeButton> createState() => _ResumeButtonState();
}

class _ResumeButtonState extends AppViewState<_ResumeButton> {
  var _busy = false;

  Future<void> _press(Future<void> Function() onPressed) async {
    setState(() => _busy = true);
    await onPressed();
    // Gone once the list shows it running.
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) => SButton.secondary(
    label: PartnerLocalizations.of(context).resumeOffer,
    icon: SIcons.resume,
    loading: _busy,
    expand: true,
    onPressed: switch (widget.onPressed) {
      final onPressed? => () => _press(onPressed),
      null => null,
    },
  );
}
