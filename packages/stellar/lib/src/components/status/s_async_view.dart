import 'package:kernel/kernel.dart';

import 's_error_view.dart';
import 's_loading_view.dart';

/// Shows loading, error (with retry) or the data of an [AsyncValue].
class SAsyncView<T> extends StatelessWidget {
  const SAsyncView({
    required this.value,
    required this.builder,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) builder;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncData(:final value) => builder(context, value),
    AsyncError(:final error) => SErrorView(
      failure: error is AppFailure ? error : UnknownFailure(error),
      onRetry: onRetry,
    ),
    _ => const SLoadingView(),
  };
}
