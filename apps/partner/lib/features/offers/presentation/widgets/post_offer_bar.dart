import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../domain/offer.dart';
import '../offer_draft_view_model.dart';

/// The post button, with what's about to go up over it: the pieces and
/// when it ends.
class PostOfferBar extends StatelessWidget {
  const PostOfferBar({
    required this.state,
    required this.onPost,
    required this.loading,
    super.key,
  });

  final NewOfferState state;
  final VoidCallback onPost;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final summary = _summary(s, Localizations.localeOf(context).languageCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: Space.sm,
      children: [
        if (summary != null)
          SText(
            summary,
            variant: TextVariant.caption,
            color: SColor.textMuted,
            align: TextAlign.center,
          ),
        SButton(
          label: s.postOffer,
          onPressed: onPost,
          loading: loading,
          expand: true,
        ),
      ],
    );
  }

  /// Null while the pieces or the end aren't filled in right.
  String? _summary(PartnerLocalizations s, String language) {
    final endsAt = state.endsAt;
    final pieces = state.pieces;
    if (endsAt == null) return null;
    if (state.type == OfferType.limited && pieces == null) return null;
    final count = pieces == null ? s.noLimit : s.piecesCount(pieces);
    final now = ServerClock.now();
    final today =
        endsAt.year == now.year &&
        endsAt.month == now.month &&
        endsAt.day == now.day;
    final when = s.dayAndTime(
      today ? s.dayToday : formatDayMonth(endsAt, languageCode: language),
      formatTime(endsAt, languageCode: language),
    );
    return s.postSummary(count, when);
  }
}
