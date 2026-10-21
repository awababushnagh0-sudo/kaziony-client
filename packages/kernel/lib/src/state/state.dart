import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

// Riverpod is the state engine behind these classes. Apps never import it:
// they use the base classes below and the provider types re-exported here.
export 'package:flutter_riverpod/flutter_riverpod.dart'
    show
        AsyncData,
        AsyncError,
        AsyncLoading,
        AsyncNotifierProvider,
        AsyncValueExtensions,
        AsyncValue,
        FutureProvider,
        NotifierProvider,
        Provider,
        ProviderContainer,
        Ref,
        StreamProvider,
        WidgetRef;
export 'package:flutter_riverpod/misc.dart' show Override, ProviderListenable;

/// Holds the state of a screen or feature and the actions that change it.
///
/// ```dart
/// final loginViewModel =
///     NotifierProvider.autoDispose<LoginViewModel, LoginState>(LoginViewModel.new);
///
/// class LoginViewModel extends ViewModel<LoginState> {
///   @override
///   LoginState build() => const LoginState();
/// }
/// ```
abstract class ViewModel<S> extends Notifier<S> {}

/// Like [ViewModel], for state that is loaded asynchronously (e.g. from the
/// API). The UI gets an [AsyncValue] with loading, data and error states.
abstract class AsyncViewModel<S> extends AsyncNotifier<S> {}

/// A screen or widget that reads view models: `ref.watch(provider)`.
abstract class AppView extends ConsumerWidget {
  const AppView({super.key});
}

/// An [AppView] with its own mutable state (controllers, animations).
abstract class AppStatefulView extends ConsumerStatefulWidget {
  const AppStatefulView({super.key});
}

/// The state of an [AppStatefulView]. Has `ref` like [AppView].
abstract class AppViewState<T extends AppStatefulView>
    extends ConsumerState<T> {}

/// Reads view models inside a regular widget tree without a full [AppView].
class AppConsumer extends StatelessWidget {
  const AppConsumer({required this.builder, super.key});

  final Widget Function(BuildContext context, WidgetRef ref) builder;

  @override
  Widget build(BuildContext context) =>
      Consumer(builder: (context, ref, _) => builder(context, ref));
}

/// The root of every app: holds all view models and services.
/// Use [overrides] to plug in configuration or fakes in tests.
class AppScope extends StatelessWidget {
  const AppScope({required this.child, this.overrides = const [], super.key});

  final Widget child;
  final List<Override> overrides;

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: overrides,
    // Riverpod retries failed providers by itself (up to 10 times). We
    // don't: the network layer already retries GETs on bad connections,
    // and screens show the error with a "Try again" button.
    retry: _noRetry,
    child: child,
  );
}

Duration? _noRetry(int retryCount, Object error) => null;
