import 'package:kernel/kernel.dart';

import 's_error_view.dart';
import 's_loading_view.dart';

/// Shows loading, error (with retry) or the data of an [AsyncValue].
///
/// While loading it shows [loading]: an `SSkeleton` shaped like the data
/// (cards, rows, a record's page), or a spinner when none is given.
class SAsyncView<T> extends StatelessWidget {
  const SAsyncView({
    required this.value,
    required this.builder,
    this.onRetry,
    this.loading,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback? onRetry;
  final Widget? loading;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncData(:final value) => builder(context, value),
    AsyncError(:final error) => SErrorView(
      failure: error is AppFailure ? error : UnknownFailure(error),
      onRetry: onRetry,
    ),
    _ => loading ?? const SLoadingView(),
  };
}
