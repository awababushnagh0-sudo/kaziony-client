import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Asks before the user leaves a page with unsaved work, however they leave:
/// a link, the side menu, the back button or the browser's back.
///
/// Wrap the page's content in it, and give the page's route
/// `onExit: LeaveGuard.onExit`.
class LeaveGuard extends StatefulWidget {
  const LeaveGuard({
    required this.active,
    required this.confirm,
    required this.child,
    super.key,
  });

  /// There's unsaved work, so leaving asks first.
  final bool active;

  /// Asks the user; true lets them leave.
  final Future<bool> Function(BuildContext context) confirm;
  final Widget child;

  /// The guards on screen, by the page they're on: go_router hands
  /// [onExit] the page, not a context inside it.
  static final _guards = <LocalKey, _LeaveGuardState>{};

  /// For `GoRoute.onExit`: lets the page go, unless it has an active guard
  /// and the user chooses to stay.
  static FutureOr<bool> onExit(BuildContext context, GoRouterState state) {
    final guard = _guards[state.pageKey];
    if (guard == null || !guard.widget.active) return true;
    return guard.widget.confirm(guard.context);
  }

  @override
  State<LeaveGuard> createState() => _LeaveGuardState();
}

class _LeaveGuardState extends State<LeaveGuard> {
  LocalKey? _page;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final page = GoRouterState.of(context).pageKey;
    if (page == _page) return;
    _forget();
    _page = page;
    LeaveGuard._guards[page] = this;
  }

  @override
  void dispose() {
    _forget();
    super.dispose();
  }

  void _forget() {
    if (LeaveGuard._guards[_page] == this) LeaveGuard._guards.remove(_page);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
