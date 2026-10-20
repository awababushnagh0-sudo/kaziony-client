import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Encrypted storage for secrets (tokens). Keychain on iOS, Keystore on Android.
abstract interface class SecureStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Plain storage for settings (language, last selected store).
abstract interface class SettingsStore {
  Future<String?> getString(String key);
  Future<void> setString(String key, String value);
  Future<void> remove(String key);
}

class DeviceSecureStore implements SecureStore {
  const DeviceSecureStore();

  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class DeviceSettingsStore implements SettingsStore {
  DeviceSettingsStore();

  final _prefs = SharedPreferencesAsync();

  @override
  Future<String?> getString(String key) => _prefs.getString(key);

  @override
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  Future<void> remove(String key) => _prefs.remove(key);
}

final secureStoreProvider = Provider<SecureStore>(
  (ref) => const DeviceSecureStore(),
);

final settingsStoreProvider = Provider<SettingsStore>(
  (ref) => DeviceSettingsStore(),
);
