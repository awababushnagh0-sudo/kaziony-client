import 'package:flutter/material.dart';

import '../../foundation/s_kit.dart';
import '../../foundation/s_tokens.dart';
import '../../l10n/generated/stellar_localizations.dart';
import '../status/s_error_view.dart';
import 's_paged_list_renderer.dart';

/// How close to the end (in pixels) the next rows start loading, so they
/// are usually there before the user gets to them.
const _loadAhead = 600.0;

class MaterialPagedListRenderer implements PagedListRenderer {
  const MaterialPagedListRenderer();

  @override
  Widget render(BuildContext context, PagedListSpec spec) {
    final c = context.colors;
    final footer = spec.hasMore || spec.loadingMore || spec.moreFailure != null;
    return RefreshIndicator(
      onRefresh: spec.onRefresh,
      color: c.primary,
      backgroundColor: c.surface,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (spec.hasMore &&
              !spec.loadingMore &&
              spec.moreFailure == null &&
              notification.metrics.extentAfter < _loadAhead) {
            spec.onLoadMore();
          }
          return false;
        },
        child: ListView.separated(
          // Pulling down works even when the rows don't fill the screen.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: Space.xl),
          itemCount: spec.itemCount + (footer ? 1 : 0),
          separatorBuilder: (_, index) => index < spec.itemCount - 1
              ? const Divider(indent: Space.lg, endIndent: Space.lg)
              : const SizedBox.shrink(),
          itemBuilder: (context, index) => index < spec.itemCount
              ? spec.itemBuilder(context, index)
              : _Footer(spec: spec),
        ),
      ),
    );
  }
}

/// A spinner while more rows load, or what went wrong with a retry.
class _Footer extends StatelessWidget {
  const _Footer({required this.spec});

  final PagedListSpec spec;

  @override
  Widget build(BuildContext context) {
    final failure = spec.moreFailure;
    return Padding(
      padding: const EdgeInsets.all(Space.lg),
      child: failure == null
          ? Center(
              child: spec.loadingMore
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
                  onPressed: spec.onLoadMore,
                  child: Text(StellarLocalizations.of(context).retry),
                ),
              ],
            ),
    );
  }
}
