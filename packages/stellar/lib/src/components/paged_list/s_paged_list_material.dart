import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart' show AppFailure;

import '../../foundation/s_scope.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../status/s_error_view.dart';
import 's_paged_list.dart';

/// How close to the end (in pixels) the next rows start loading, so they
/// are usually there before the user gets to them.
const _loadAhead = 600.0;

/// [SPagedList] as a Material [ListView] in a [RefreshIndicator].
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

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final loading = hasMore || loadingMore || moreFailure != null;
    final endNote = this.endNote;
    final footer = loading || endNote != null;
    final header = this.header;
    // Rows start after the header, if any.
    final first = header == null ? 0 : 1;
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
        child: ListView.separated(
          // Pulling down works even when the rows don't fill the screen.
          physics: const AlwaysScrollableScrollPhysics(),
          // Plus the room a floating button asks for (SScaffold.floating).
          padding: EdgeInsets.only(
            bottom: Space.xl + MediaQuery.paddingOf(context).bottom,
          ),
          itemCount: first + itemCount + (footer ? 1 : 0),
          // Lines (or gaps, between cards) only between rows.
          separatorBuilder: (_, index) =>
              index >= first && index < first + itemCount - 1
              ? divided
                    ? const Divider(indent: Space.lg, endIndent: Space.lg)
                    : const Gap(Space.sm)
              : const SizedBox.shrink(),
          itemBuilder: (context, index) {
            if (header != null && index == 0) return header;
            final row = index - first;
            if (row < itemCount) return itemBuilder(context, row);
            if (loading || endNote == null) {
              return _Footer(
                loadingMore: loadingMore,
                failure: moreFailure,
                onRetry: onLoadMore,
              );
            }
            return Padding(
              padding: const EdgeInsets.all(Space.lg),
              child: Text(
                endNote,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.style.text.tiny,
                  color: c.textSubtle,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// A spinner while more rows load, or what went wrong with a retry.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.loadingMore,
    required this.failure,
    required this.onRetry,
  });

  final bool loadingMore;
  final AppFailure? failure;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final failure = this.failure;
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
