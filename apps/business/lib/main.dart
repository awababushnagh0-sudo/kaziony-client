import 'package:kernel/kernel.dart';

import 'app/business_app.dart';
import 'app/dependencies.dart';

/// Run against the local backend:
///   flutter run
/// or another server:
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.20:3000
void main() => bootstrap(
  config: AppConfig.fromEnvironment(AppKind.business),
  overrides: dependencies,
  app: () => const BusinessApp(),
);
