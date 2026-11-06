import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart' show AppFailure;

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../skeleton/s_skeleton.dart';
import '../status/s_error_view.dart';
import 's_paged_list.dart';

/// How close to the end (in pixels) the next rows start loading, so they
/// are usually there before the user gets to them.
const _loadAhead = 600.0;

/// [SPagedList] as slivers in a [CustomScrollView], in a
/// [RefreshIndicator].
class SPagedListMaterial extends StatelessWidget implements SPagedList {
  const SPagedListMaterial({
    required this.itemCount,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    this.hasMore = false,
    this.loadingMore = false,
    this.moreFailure,
    this.header,
    this.endNote,
    this.divided = true,
    this.placeholder,
    super.key,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;
  final bool hasMore;
  final bool loadingMore;
  final AppFailure? moreFailure;
  final Widget? header;
  final String? endNote;

  /// Lines between the rows; otherwise a gap, for rows that are cards.
  final bool divided;
  final Widget? placeholder;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final loading = hasMore || loadingMore || moreFailure != null;
    final header = this.header;
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: c.primary,
      backgroundColor: c.surface,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (hasMore &&
              !loadingMore &&
              moreFailure == null &&
              notification.metrics.extentAfter < _loadAhead) {
            onLoadMore();
          }
          return false;
        },
        child: CustomScrollView(
          // Pulling down works even when the rows don't fill the screen.
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (header != null) SliverToBoxAdapter(child: header),
            SliverPadding(
              // Cards stand apart from what's above them, as from each
              // other; lined rows start right under it.
              padding: EdgeInsets.only(top: divided ? 0 : Space.md),
              sliver: SliverList.separated(
                itemCount: itemCount,
                itemBuilder: itemBuilder,
                separatorBuilder: (_, _) => divided
                    ? const Divider(indent: Space.lg, endIndent: Space.lg)
                    : const Gap(Space.sm),
              ),
            ),
            SliverPadding(
              // Plus the room a floating button asks for
              // (SScaffold.floating).
              padding: EdgeInsets.only(
                bottom: Space.xl + MediaQuery.paddingOf(context).bottom,
              ),
              sliver: SliverToBoxAdapter(
                child: switch ((loading, endNote)) {
                  (true, _) => _Footer(
                    loadingMore: loadingMore,
                    placeholder: placeholder,
                    failure: moreFailure,
                    onRetry: onLoadMore,
                  ),
                  (false, final String note) => _EndNote(note),
                  _ => null,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quiet words under the last row, once everything has loaded.
class _EndNote extends StatelessWidget {
  const _EndNote(this.note);

  final String note;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(Space.lg),
    child: Text(
      note,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: context.style.text.tiny,
        color: context.colors.textSubtle,
      ),
    ),
  );
}

/// The next row's skeleton (or a spinner) while more rows load, or what
/// went wrong with a retry.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.loadingMore,
    required this.placeholder,
    required this.failure,
    required this.onRetry,
  });

  final bool loadingMore;
  final Widget? placeholder;
  final AppFailure? failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final failure = this.failure;
    final placeholder = this.placeholder;
    if (failure == null && loadingMore && placeholder != null) {
      // Where the next row will be, so it seems to fill in.
      return SSkeleton(child: placeholder);
    }
    return Padding(
      padding: const EdgeInsets.all(Space.lg),
      child: failure == null
          ? Center(
              child: loadingMore
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            )
          : Column(
              children: [
                Text(
                  failureMessage(context, failure),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.textMuted),
                ),
                TextButton(
                  onPressed: onRetry,
                  child: Text(StellarLocalizations.of(context).retry),
                ),
              ],
            ),
    );
  }
}
