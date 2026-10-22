import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:offers_api/auth.dart' as api;

import '../config/app_config.dart';
import '../network/api.dart';
import '../result/result.dart';

enum UpdateStatus { checking, upToDate, updateRequired }

/// Asks the backend for the minimum supported version of this app.
/// Never blocks when offline: only a confirmed "too old" stops the app.
class VersionGate extends Notifier<UpdateStatus> {
  @override
  UpdateStatus build() {
    unawaited(Future.microtask(check));
    return UpdateStatus.checking;
  }

  /// Dev menu: pretend the backend requires an update.
  void debugRequireUpdate() => state = UpdateStatus.updateRequired;

  Future<void> check() async {
    final publicApi = ref.read(publicApiProvider);
    final client = publicApi.client(api.AppConfigClient.new);
    final result = await publicApi.guard(client.getAppConfig);
    if (!ref.mounted) return;

    final kind = ref.read(appConfigProvider).kind;
    final installed = ref.read(appInfoProvider).version;
    state = switch (result) {
      Ok(:final value) =>
        compareVersions(installed, _minVersion(value, kind)) < 0
            ? UpdateStatus.updateRequired
            : UpdateStatus.upToDate,
      Err() => UpdateStatus.upToDate,
    };
  }
}

String _minVersion(api.AppConfigDto config, AppKind kind) => switch (kind) {
  AppKind.partner => config.partner.minVersion,
  AppKind.customer => config.customer.minVersion,
  AppKind.admin => config.admin.minVersion,
};

/// Compares "1.2.10" with "1.10.0" by numbers. Negative if [a] is older.
int compareVersions(String a, String b) {
  List<int> parts(String v) =>
      v.split('+').first.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  final x = parts(a), y = parts(b);
  for (var i = 0; i < 3; i++) {
    final left = i < x.length ? x[i] : 0;
    final right = i < y.length ? y[i] : 0;
    if (left != right) return left.compareTo(right);
  }
  return 0;
}

final versionGateProvider = NotifierProvider<VersionGate, UpdateStatus>(
  VersionGate.new,
);
