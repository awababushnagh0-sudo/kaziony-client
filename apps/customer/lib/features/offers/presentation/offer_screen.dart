import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../bookings/presentation/reserve_sheet.dart';
import '../domain/offer.dart';
import 'offer_texts.dart';
import 'offer_view_model.dart';

/// One offer: its photo and prices, the store, how much is left and until
/// when, how picking up works, and the way to reserve it.
class OfferScreen extends AppView {
  const OfferScreen({required this.offerId, super.key});

  final String offerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(offerViewModel(offerId));
    final shown = detail.value;
    return SScaffold(
      // Loaded, the page opens on the offer's photo, with its own back
      // button; loading or failing, it keeps the app bar's.
      showAppBar: shown == null,
      underStatusBar: shown != null,
      padded: shown == null,
      bottom: shown == null ? null : _Footer(detail: shown),
      body: SAsyncView(
        value: detail,
        onRetry: () => ref.invalidate(offerViewModel(offerId)),
        builder: (context, detail) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(offer: detail.offer),
              _Body(detail: detail),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return SDealHeader(
      imageUrl: offer.imageUrl,
      title: offer.title,
      price: s.price(context, offer.offerPrice),
      originalPrice: s.price(context, offer.originalPrice),
      discountLabel: s.discountOff(offer.discountPercent),
      status: null,
      onBack: context.pop,
      action: null,
    );
  }
}

class _Body extends AppView {
  const _Body({required this.detail});

  final OfferDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final offer = detail.offer;
    final now = ref.watch(minuteClockProvider).value ?? DateTime.now();
    final description = offer.description;
    final total = offer.total;
    final branches = [
      for (final branch in detail.branches)
        [
          branch.name,
          if (branch.distanceKm case final km?) s.distance(km),
        ].join(' · '),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Gap(Space.md),
        SListTile(
          leading: SImage(offer.store.logoUrl),
          title: offer.store.name,
          subtitle: offer.store.category.name(language),
        ),
        Padding(
          padding: const EdgeInsets.all(Space.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: Space.lg,
            children: [
              if (description != null && description.isNotEmpty)
                SText(description, color: SColor.textMuted),
              if (offer.limited && total != null && total > 0)
                SDealStock(
                  label: s.piecesOfTotal(offer.remaining ?? 0, total),
                  note: s.endsLong(context, offer, now),
                  left: (offer.remaining ?? 0) / total,
                )
              else
                SText(
                  s.endsLong(context, offer, now),
                  weight: SFontWeight.semibold,
                ),
            ],
          ),
        ),
        if (offer.limited)
          SListTile(
            icon: SIcons.hourglass,
            title: s.holdTitle(offer.claimWindowMinutes),
            subtitle: s.holdMessage,
          )
        else
          SListTile(
            icon: SIcons.hourglass,
            title: s.untilEndTitle,
            subtitle: s.untilEndMessage,
          ),
        SListTile(icon: SIcons.cash, title: s.payTitle, subtitle: s.payMessage),
        SListTile(
          icon: SIcons.location,
          title: branches.length == 1 ? s.pickupOne : s.pickupAny,
          subtitle: branches.join('\n'),
        ),
        if (offer.maxPerUser case final most?)
          SListTile(icon: SIcons.user, title: s.limitPerCustomer(most)),
        const Gap(Space.lg),
      ],
    );
  }
}

/// The price, and the way to reserve: signing in first, or the pickup code
/// once reserved.
class _Footer extends AppView {
  const _Footer({required this.detail});

  final OfferDetail detail;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final offer = detail.offer;
    final signedIn = ref.watch(sessionProvider) is SignedIn;
    final booking = detail.myBookingId;
    return SDealFooter(
      price: s.price(context, offer.offerPrice),
      originalPrice: s.price(context, offer.originalPrice),
      action: switch (booking) {
        final id? => SButton(
          label: s.showMyCode,
          expand: true,
          onPressed: () => context.push(Routes.booking(id)),
        ),
        null when offer.maxReservable < 1 => SButton(
          label: s.soldOut,
          expand: true,
          onPressed: null,
        ),
        null => SButton(
          label: s.reserveNow,
          expand: true,
          onPressed: signedIn
              ? () => reserve(context, ref, offer)
              : () => context.push(Routes.signIn),
        ),
      },
    );
  }
}
