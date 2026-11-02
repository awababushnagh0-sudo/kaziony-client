import 'package:kernel/kernel.dart';

import 'core/app/customer_app.dart';
import 'core/providers/dependencies.dart';
import 'features/location/domain/browse_location.dart';

/// Run against the local backend:
///   flutter run --dart-define-from-file=config/dev.json
/// or another server:
///   flutter run --dart-define=API_BASE_URL=http://192.168.1.20:3000
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Read before the first frame, so someone who has chosen a place never
  // sees the welcome pages flash by.
  final location = await BrowseLocationController.readSaved(
    DeviceSettingsStore(),
  );
  await bootstrap(
    config: AppConfig.fromEnvironment(AppKind.customer),
    overrides: [
      ...dependencies,
      browseLocationProvider.overrideWith(
        () => BrowseLocationController(location),
      ),
    ],
    app: () => const CustomerApp(),
  );
}
