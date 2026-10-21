import 'package:kernel/kernel.dart';

import 'core/app/admin_app.dart';
import 'core/providers/dependencies.dart';

/// Run against the local backend:
///   flutter run -d chrome --dart-define-from-file=config/dev.json
void main() => bootstrap(
  config: AppConfig.fromEnvironment(AppKind.admin),
  overrides: dependencies,
  app: () => const AdminApp(),
);
