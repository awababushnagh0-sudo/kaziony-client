import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../../core/l10n/generated/partner_localizations.dart';
import '../../domain/offer.dart';
import '../offer_draft_view_model.dart';
import 'offer_fields.dart';

/// The post button, with what's about to go up over it: the pieces, when
/// it ends, and the branches when it isn't all of them, so an offer isn't
/// posted to one branch by mistake.
class PostOfferBar extends AppView {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final summary = _summary(s, Localizations.localeOf(context).languageCode, [
      for (final branch in activeBranches(ref))
        if (state.branchIds?.contains(branch.id) ?? true) branch.name,
    ]);
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
  String? _summary(
    PartnerLocalizations s,
    String language,
    List<String> branches,
  ) {
    final endsAt = state.endsAt;
    final pieces = state.pieces;
    if (endsAt == null) return null;
    if (state.type == OfferType.limited && pieces == null) return null;
    final count = pieces == null ? s.noLimit : s.piecesCount(pieces);
    final now = DateTime.now();
    final today =
        endsAt.year == now.year &&
        endsAt.month == now.month &&
        endsAt.day == now.day;
    final when = s.dayAndTime(
      today ? s.dayToday : formatDayMonth(endsAt, languageCode: language),
      formatTime(endsAt, languageCode: language),
    );
    // All of them, or none (the form says to choose one): no need to say.
    final everywhere = state.branchIds == null || branches.isEmpty;
    return everywhere
        ? s.postSummary(count, when)
        : s.postSummaryAt(count, when, branches.join(s.listSeparator));
  }
}
