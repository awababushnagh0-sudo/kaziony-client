import 'package:flutter/material.dart';
import 'package:kernel/kernel.dart';

import '../dev_panel.dart';

/// Point the app at another backend (local, a teammate's laptop, staging).
class ServerTab extends AppStatefulView {
  const ServerTab({super.key});

  @override
  AppViewState<ServerTab> createState() => _ServerTabState();
}

class _ServerTabState extends AppViewState<ServerTab> {
  final _custom = TextEditingController();
  String? _testing;
  final _results = <String, String>{};

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  Future<void> _test(String url) async {
    setState(() => _testing = url);
    final problem = await pingServer(url);
    if (!mounted) return;
    setState(() {
      _testing = null;
      _results[url] = problem == null ? '✓ reachable' : '✗ $problem';
    });
  }

  /// Switching servers logs out: tokens from one server mean nothing on another.
  Future<void> _use(String? url) async {
    await ref.read(sessionProvider.notifier).signOut();
    await ref.read(devSettingsProvider.notifier).setServer(url);
    await ref.read(versionGateProvider.notifier).check();
    if (mounted) {
      showDevSnack(context, 'Now using ${ref.read(apiBaseUrlProvider)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(apiBaseUrlProvider);
    final buildUrl = ref.watch(appConfigProvider).apiBaseUrl;
    final presets = <(String, String)>{
      ('Build default', buildUrl),
      ('This computer (simulator / emulator)', localBackendUrl()),
      ('localhost:3000', 'http://localhost:3000'),
      ('Android emulator → host', 'http://10.0.2.2:3000'),
    };

    Widget serverTile(String label, String url) => ListTile(
      leading: Icon(
        url == active ? Icons.radio_button_checked : Icons.radio_button_off,
        color: url == active ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(label),
      subtitle: Text(
        [url, if (_results[url] != null) _results[url]!].join('\n'),
        style: monospace,
      ),
      isThreeLine: _results[url] != null,
      trailing: _testing == url
          ? const SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : TextButton(onPressed: () => _test(url), child: const Text('Test')),
      onTap: url == active ? null : () => _use(url == buildUrl ? null : url),
    );

    return ListView(
      children: [
        DevSection(title: 'Active', children: [DevInfoRow('Server', active)]),
        DevSection(
          title: 'Presets (tap to switch, logs you out)',
          children: [
            for (final (label, url) in presets) serverTile(label, url),
          ],
        ),
        DevSection(
          title: 'Custom (e.g. your computer on Wi-Fi)',
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _custom,
                keyboardType: TextInputType.url,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'http://192.168.1.20:3000',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () => _test(_custom.text.trim()),
                    child: const Text('Test'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      final url = _custom.text.trim().replaceFirst(
                        RegExp(r'/+$'),
                        '',
                      );
                      if (Uri.tryParse(url)?.hasScheme ?? false) _use(url);
                    },
                    child: const Text('Use this server'),
                  ),
                ],
              ),
            ),
            if (_results[_custom.text.trim()] != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(_results[_custom.text.trim()]!, style: monospace),
              ),
          ],
        ),
      ],
    );
  }
}
