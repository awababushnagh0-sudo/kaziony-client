import 'package:kernel/kernel.dart';

import 'core/app/business_app.dart';
import 'core/providers/dependencies.dart';

/// Run against the local backend:
///   flutter run
/// or another server:
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.20:3000
void main() => bootstrap(
  config: AppConfig.fromEnvironment(AppKind.business),
  overrides: dependencies,
  app: () => const BusinessApp(),
);
