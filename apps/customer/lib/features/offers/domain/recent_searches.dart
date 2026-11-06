import 'dart:convert';

import 'package:kernel/kernel.dart';

/// The words the customer searched lately, newest first, remembered on the
/// phone for the Search tab to offer again.
class RecentSearches extends ViewModel<List<String>> {
  static const _key = 'search.recent';

  /// Enough to pick from at a glance.
  static const max = 8;

  /// What the phone remembered; changes wait for it, so they never write
  /// over searches not read yet.
  late Future<void> _loaded;

  @override
  List<String> build() {
    _loaded = _load();
    return const [];
  }

  /// Puts [search] first, once (whatever its case), keeping the newest
  /// [max].
  Future<void> add(String search) async {
    final words = search.trim();
    if (words.isEmpty) return;
    await _change(
      (searches) => [words, ..._without(searches, words)].take(max).toList(),
    );
  }

  Future<void> remove(String search) =>
      _change((searches) => _without(searches, search));

  Future<void> clear() => _change((_) => const []);

  Future<void> _change(List<String> Function(List<String>) change) async {
    await _loaded;
    if (!ref.mounted) return;
    state = change(state);
    await ref.read(settingsStoreProvider).setString(_key, jsonEncode(state));
  }

  Future<void> _load() async {
    final raw = await ref.read(settingsStoreProvider).getString(_key);
    if (raw == null || !ref.mounted) return;
    try {
      state = (jsonDecode(raw) as List<Object?>).whereType<String>().toList();
    } on Object {
      // Not a list we wrote: start again.
    }
  }

  static List<String> _without(List<String> searches, String search) =>
      searches.where((s) => !_same(s, search)).toList();

  static bool _same(String a, String b) => a.toLowerCase() == b.toLowerCase();
}

final recentSearchesProvider =
    NotifierProvider.autoDispose<RecentSearches, List<String>>(
      RecentSearches.new,
    );
