import 'package:kernel/kernel.dart';

import '../../features/store/domain/current_store.dart';
import 'routes.dart';

/// Screens shown before the tabs. Once in a store, the user leaves them.
const _entryScreens = {
  Routes.splash,
  Routes.update,
  Routes.login,
  Routes.changePassword,
  Routes.chooseStore,
  Routes.noStore,
};

/// Where the user must be, given the session, the store picked on this
/// device and the version check. Null means "stay where you are".
String? redirectFor({
  required SessionState session,
  required AsyncValue<String?> chosenStore,
  required UpdateStatus update,
  required String location,
}) {
  final target = switch ((update, session)) {
    (UpdateStatus.updateRequired, _) => Routes.update,
    (_, SessionRestoring()) => Routes.splash,
    (_, SignedOut()) => Routes.login,
    (_, SignedIn(:final user)) when user.mustChangePassword =>
      Routes.changePassword,
    (_, SignedIn(:final user)) => switch (storeAccessFor(
      user.memberships,
      chosenStore,
    )) {
      StoreAccessLoading() => Routes.splash,
      NoStore() => Routes.noStore,
      MustChooseStore() => Routes.chooseStore,
      // In a store: stay on app screens, leave the entry screens.
      InStore(:final store) =>
        _entryScreens.contains(location) ||
                (!store.isOwner && Routes.ownerOnly(location))
            ? Routes.home
            : null,
    },
  };
  return target == location ? null : target;
}
