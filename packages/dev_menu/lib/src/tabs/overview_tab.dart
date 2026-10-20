import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';

import '../dev_panel.dart';

class OverviewTab extends AppView {
  const OverviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final info = ref.watch(appInfoProvider);
    final session = ref.watch(sessionProvider);
    final update = ref.watch(versionGateProvider);
    final dev = ref.watch(devSettingsProvider);
    final locale = ref.watch(localeProvider);
    final sessionController = ref.read(sessionProvider.notifier);
    final expiry = _tokenExpiry(sessionController.debugAccessToken);

    Future<void> run(String done, Future<void> Function() action) async {
      await action();
      if (context.mounted) showDevSnack(context, done);
    }

    return ListView(
      children: [
        DevSection(
          title: 'App',
          children: [
            DevInfoRow('Build', '${config.kind.name} · ${appEnv.name}'),
            DevInfoRow('Version', '${info.version} (${info.buildNumber})'),
            DevInfoRow('Server', ref.watch(apiBaseUrlProvider)),
            DevInfoRow('Update check', update.name),
          ],
        ),
        DevSection(
          title: 'Session',
          children: [
            ...switch (session) {
              SessionRestoring() => [const DevInfoRow('State', 'restoring')],
              SignedOut(:final expired) => [
                DevInfoRow(
                  'State',
                  expired ? 'signed out (expired)' : 'signed out',
                ),
              ],
              SignedIn(:final user) => [
                DevInfoRow('User', '${user.name ?? '-'} · ${user.role.name}'),
                DevInfoRow('ID', user.id),
                DevInfoRow('Phone / email', user.phone ?? user.email ?? '-'),
                DevInfoRow(
                  'Stores',
                  user.memberships.isEmpty
                      ? '-'
                      : user.memberships
                            .map(
                              (m) =>
                                  '${m.storeName} (${m.isOwner ? 'owner' : 'staff'})',
                            )
                            .join('\n'),
                ),
                DevInfoRow(
                  'Access token',
                  expiry == null
                      ? 'invalid / expired'
                      : 'expires ${formatTime(expiry)} '
                            '(${expiry.difference(DateTime.now()).inMinutes} min)',
                ),
              ],
            },
          ],
        ),
        DevSection(
          title: 'Test actions',
          children: [
            ListTile(
              leading: const Icon(Icons.timer_off_outlined),
              title: const Text('Expire access token'),
              subtitle: const Text('The next request gets a 401 and refreshes'),
              onTap: () => run(
                'Access token expired',
                sessionController.debugExpireAccessToken,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.autorenew),
              title: const Text('Refresh tokens now'),
              onTap: () async {
                final ok = await sessionController.refreshTokens();
                if (context.mounted) {
                  showDevSnack(context, ok ? 'Refreshed' : 'Refresh failed');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_search_outlined),
              title: const Text('Reload user (/auth/me)'),
              onTap: () => run('User reloaded', sessionController.reloadUser),
            ),
            ListTile(
              leading: const Icon(Icons.system_update_outlined),
              title: const Text('Simulate "update required"'),
              onTap: () => run(
                'Update required (re-check to undo)',
                () async =>
                    ref.read(versionGateProvider.notifier).debugRequireUpdate(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Re-check minimum version'),
              onTap: () =>
                  run('Checked', ref.read(versionGateProvider.notifier).check),
            ),
            SwitchListTile(
              secondary: const Icon(Icons.slow_motion_video),
              title: const Text('Slow network (+2 s per request)'),
              value: dev.slowNetwork,
              onChanged: ref.read(devSettingsProvider.notifier).setSlowNetwork,
            ),
            SwitchListTile(
              secondary: const Icon(Icons.wifi_off),
              title: const Text('Offline mode'),
              subtitle: const Text('Every request fails like no connection'),
              value: dev.offline,
              onChanged: ref.read(devSettingsProvider.notifier).setOffline,
            ),
            ListTile(
              leading: const Icon(Icons.translate),
              title: Text(
                'Language: ${locale.languageCode} → '
                '${locale.languageCode == 'ar' ? 'en' : 'ar'}',
              ),
              onTap: () => ref
                  .read(localeProvider.notifier)
                  .setLocale(Locale(locale.languageCode == 'ar' ? 'en' : 'ar')),
            ),
            ListTile(
              leading: const Icon(Icons.error_outline),
              title: const Text('Throw a test error'),
              subtitle: const Text('Should appear in Logs (error reporting)'),
              onTap: () {
                unawaited(
                  Future<void>(
                    () => throw StateError('Test error from the dev menu'),
                  ),
                );
                showDevSnack(context, 'Thrown');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log out'),
              onTap: () => run('Logged out', sessionController.signOut),
            ),
            ListTile(
              leading: Icon(
                Icons.delete_forever_outlined,
                color: Colors.red.shade700,
              ),
              title: const Text('Clear local data'),
              subtitle: const Text(
                'Log out, reset language and server, clear dev logs',
              ),
              onTap: () => run('Local data cleared', () async {
                await sessionController.signOut();
                await ref.read(settingsStoreProvider).remove('settings.locale');
                await ref
                    .read(localeProvider.notifier)
                    .setLocale(supportedLocales.first);
                await ref.read(devSettingsProvider.notifier).setServer(null);
                ref.read(devLogProvider).clear();
              }),
            ),
          ],
        ),
      ],
    );
  }
}

/// Reads the `exp` claim of a JWT (no verification; display only).
DateTime? _tokenExpiry(String? token) {
  final parts = token?.split('.');
  if (parts == null || parts.length != 3) return null;
  try {
    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );
    final exp = payload is Map ? payload['exp'] : null;
    return exp is int ? DateTime.fromMillisecondsSinceEpoch(exp * 1000) : null;
  } on FormatException {
    return null;
  }
}
