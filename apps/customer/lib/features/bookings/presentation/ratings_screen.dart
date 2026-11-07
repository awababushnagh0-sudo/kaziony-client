import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/customer_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/booking.dart';
import 'ratings_view_model.dart';
import 'widgets/booking_tiles_skeleton.dart';

/// The stars the customer gave stores, the latest first: each pickup's
/// picture, the store, what it was and when, and the stars. Opens the
/// booking.
class RatingsScreen extends AppView {
  const RatingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = CustomerLocalizations.of(context);
    final viewModel = ref.read(ratingsViewModel.notifier);
    return SScaffold(
      title: s.ratingsTitle,
      padded: false,
      body: SAsyncView(
        value: ref.watch(ratingsViewModel),
        onRetry: () => ref.invalidate(ratingsViewModel),
        loading: const Padding(
          padding: EdgeInsets.all(Space.lg),
          child: BookingTilesSkeleton(count: 5),
        ),
        builder: (context, page) {
          if (page.items.isEmpty) {
            return SEmptyView(
              icon: SIcons.ratings,
              title: s.ratingsEmptyTitle,
              message: s.ratingsEmptyMessage,
              actionLabel: s.bookingsTitle,
              actionIcon: SIcons.bookings,
              onAction: () => context.go(Routes.bookings),
            );
          }
          return SPagedList(
            divided: false,
            header: const Gap(Space.md),
            itemCount: page.items.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: Space.lg),
              child: _RatingTile(booking: page.items[index]),
            ),
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
              padding: EdgeInsets.symmetric(horizontal: Space.lg),
              child: BookingTilesSkeleton(count: 1),
            ),
          );
        },
      ),
    );
  }
}

class _RatingTile extends StatelessWidget {
  const _RatingTile({required this.booking});

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final day = formatDayMonth(
      booking.pickedUpAt ?? booking.createdAt,
      languageCode: language,
    );
    return SCard(
      onTap: () => context.push(Routes.booking(booking.id)),
      child: Row(
        spacing: Space.md,
        children: [
          SImage(booking.thumbUrl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Space.xxs,
              children: [
                SText(
                  booking.storeName,
                  weight: SFontWeight.semibold,
                  maxLines: 1,
                ),
                SText(
                  '${booking.offerTitle} · $day',
                  variant: TextVariant.caption,
                  color: SColor.textMuted,
                  maxLines: 1,
                ),
                SStarInput(
                  value: booking.myRating ?? 0,
                  starLabel: s.ratingStars,
                  small: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
