import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../store/domain/current_store.dart';
import '../domain/offer.dart';
import 'offer_view_model.dart';
import 'widgets/offer_labels.dart';

/// One offer: what customers see, how it's selling, when it runs, and the
/// owner's actions.
class OfferScreen extends AppView {
  const OfferScreen({required this.offerId, super.key});

  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offer = ref.watch(offerViewModel(offerId));
    final isOwner = ref.watch(currentStoreProvider)?.isOwner ?? false;
    final shown = offer.value;
    return SScaffold(
      // Loaded, the page opens on the offer's photo, with its own back
      // button; loading or failing, it keeps the app bar's.
      showAppBar: shown == null,
      underStatusBar: shown != null,
      padded: shown == null,
      bottom: isOwner && shown != null ? _Actions(offer: shown) : null,
      body: SAsyncView(
        value: offer,
        onRetry: () => ref.invalidate(offerViewModel(offerId)),
        builder: (context, offer) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(offer: offer, isOwner: isOwner),
              Padding(
                padding: const EdgeInsets.all(Space.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: Space.lg,
                  children: [
                    if (offer.totalQuantity case final total?)
                      _Stock(offer: offer, total: total),
                    _Selling(offer: offer),
                    _Run(offer: offer),
                    if (isOwner && offer.canChange) _End(offer: offer),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.offer, required this.isOwner});

  final Offer offer;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return SDealHeader(
      imageUrl: offer.thumbUrl,
      title: offer.title,
      price: formatPrice(offer.offerPrice, languageCode: language),
      originalPrice: formatPrice(offer.originalPrice, languageCode: language),
      discountLabel: s.discountOff(offer.discountPercent),
      status: offerStatus(s, offer.state),
      onBack: context.pop,
      // Posting it again with the same values, at any time.
      action: isOwner
          ? DealAction(
              icon: SIcons.repost,
              tooltip: s.repostOffer,
              onPressed: () => context.push(
                Routes.newOffer(offer.productId, from: offer.id),
              ),
            )
          : null,
    );
  }
}

/// How much of a limited offer is left, and until when.
class _Stock extends StatelessWidget {
  const _Stock({required this.offer, required this.total});

  final Offer offer;
  final int total;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    return SDealStock(
      label: s.piecesLeft(offer.remainingQuantity ?? 0, total),
      note: s.endsAt(formatWhen(offer.endsAt, languageCode: language)),
      left: offerLeft(offer) ?? 0,
    );
  }
}

/// How it's selling: seen, reserved, picked up.
class _Selling extends StatelessWidget {
  const _Selling({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final claims = offer.claims;
    return SFigures([
      Figure(
        value: '${offer.viewCount}',
        label: s.figureViews,
        icon: SIcons.show,
      ),
      Figure(
        value: '${claims.reserved + claims.redeemed}',
        label: s.figureReserved,
        icon: SIcons.users,
      ),
      Figure(
        value: '${claims.redeemed}',
        label: s.figurePickedUp,
        icon: SIcons.check,
      ),
    ]);
  }
}

/// When it runs, what each customer gets, and what became of the
/// reservations.
class _Run extends StatelessWidget {
  const _Run({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();
    final claims = offer.claims;
    TimePoint point(String label, DateTime at) => TimePoint(
      label: label,
      time: formatTime(at, languageCode: language),
      note: isSameDay(at, now)
          ? s.dayToday
          : formatShortDay(at, languageCode: language),
    );
    return SListGroup(
      children: [
        STimeSpan(
          start: point(s.startsLabel, offer.startsAt),
          end: point(s.endsLabel, offer.endsAt),
          length: offerLength(s, offer.endsAt.difference(offer.startsAt)),
        ),
        if (offer.type == OfferType.limited)
          SFactTile(
            label: s.holdTitle,
            value: s.holdValue(offer.claimWindowMinutes),
          ),
        SFactTile(
          label: s.perCustomerLabel,
          value: offer.maxPerUser?.toString() ?? s.noLimit,
        ),
        SFactTile(
          label: s.branchesTitle,
          value: s.branchCount(offer.branchIds.length),
        ),
        // What became of its reservations.
        SFigures(look: FiguresLook.footer, title: s.claimsSection, [
          Figure(value: '${claims.reserved}', label: s.claimsReserved),
          Figure(value: '${claims.redeemed}', label: s.claimsRedeemed),
          Figure(value: '${claims.expired}', label: s.claimsExpired),
          Figure(value: '${claims.cancelled}', label: s.claimsCancelled),
        ]),
      ],
    );
  }
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

/// Ending is for good, so it stays apart from the everyday actions, and
/// asks first.
class _End extends AppView {
  const _End({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    return SButton.dangerSoft(
      label: s.endOffer,
      icon: SIcons.stop,
      expand: true,
      onPressed: () async {
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
      },
    );
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
