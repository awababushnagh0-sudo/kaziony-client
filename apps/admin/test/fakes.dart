import 'package:admin/features/activity/domain/activity_entry.dart';
import 'package:admin/features/auth/domain/auth_repository.dart';
import 'package:admin/features/dashboard/domain/dashboard_stats.dart';
import 'package:admin/features/platform/domain/platform_settings.dart';
import 'package:admin/features/platform/domain/service_area.dart';
import 'package:admin/features/reports/domain/customer_report.dart';
import 'package:admin/features/search/domain/search_term.dart';
import 'package:admin/features/stores/domain/location.dart';
import 'package:admin/features/stores/domain/store.dart';
import 'package:admin/features/system/domain/database_stats.dart';
import 'package:admin/features/system/domain/system_error.dart';
import 'package:admin/features/system/domain/system_job.dart';
import 'package:admin/features/system/domain/system_overview.dart';
import 'package:admin/features/system/domain/system_repository.dart';
import 'package:admin/features/system/domain/system_traffic.dart';
import 'package:admin/features/users/domain/dashboard_user.dart';
import 'package:kernel/kernel.dart';

SessionUser user({
  String id = 'u1',
  AccountRole role = AccountRole.admin,
  bool mustChangePassword = false,
}) => SessionUser(
  id: id,
  role: role,
  name: 'Test Admin',
  phone: null,
  email: 'admin@offers.local',
  contactPhone: null,
  mustChangePassword: mustChangePassword,
  memberships: const [],
);

/// Signed in as [signedIn], without restoring a stored session.
class FakeSession extends SessionController {
  FakeSession(this.signedIn);

  final SessionUser signedIn;

  @override
  SessionState build() => SignedIn(signedIn);
}

class FakeAuthRepository implements AuthRepository {
  Result<SessionUser> loginResult = Ok(user());
  final logins = <(String, String)>[];
  var logouts = 0;

  @override
  Future<Result<SessionUser>> login(String email, String password) async {
    logins.add((email, password));
    return loginResult;
  }

  @override
  Future<Result<SessionUser>> changePassword(
    String current,
    String next,
  ) async => Ok(user());

  @override
  Future<void> logout() async => logouts++;
}

const sampleStats = DashboardStats(
  stores: 12,
  activeStores: 10,
  liveOffers: 34,
  totalOffers: 120,
  customers: 560,
  newCustomersLast7Days: 45,
  claimsLast7Days: 78,
  redemptionRate: 0.8,
);

class FakeDashboardRepository implements DashboardRepository {
  Result<DashboardStats> result = const Ok(sampleStats);
  var calls = 0;

  @override
  Future<Result<DashboardStats>> getStats() async {
    calls++;
    return result;
  }
}

const sampleCategory = Category(
  id: 'cat-sweets',
  nameAr: 'حلويات',
  nameEn: 'Sweets',
);

StoreSummary sampleStore(int n, {bool active = true}) => StoreSummary(
  id: 'store-$n',
  name: 'Store $n',
  category: sampleCategory,
  area: 'Area $n',
  isActive: active,
  createdAt: DateTime.utc(2026, 10, n),
);

const sampleHours = OpeningHours({
  Weekday.sat: [
    OpeningShift(opens: 8 * 60, closes: 13 * 60),
    OpeningShift(opens: 16 * 60, closes: 23 * 60),
  ],
  Weekday.fri: [OpeningShift(opens: 16 * 60, closes: 23 * 60)],
});

StoreDetails sampleDetails(
  String id, {
  bool active = true,
  List<GoLiveItem> missing = const [],
  String? logoUrl,
  String? coverUrl,
}) => StoreDetails(
  id: id,
  name: 'Sweet Coast',
  category: sampleCategory,
  isActive: active,
  missingToGoLive: missing,
  createdAt: DateTime.utc(2026, 10, 15, 12),
  city: City.tripoli,
  area: 'Hay Al Andalus',
  address: 'Jaraba Street',
  latitude: 32.8872,
  longitude: 13.1913,
  openingHours: sampleHours,
  teamCount: 3,
  ratingAverage: 4.5,
  ratingCount: 37,
  pickupInstructions: 'Show your code at the cashier.',
  phone: '+218912345678',
  email: 'hello@sweetcoast.ly',
  instagramUrl: 'https://instagram.com/sweetcoast',
  logoUrl: logoUrl,
  coverUrl: coverUrl,
);

class FakeStoreRepository implements StoreRepository {
  List<StoreSummary> stores = [sampleStore(1), sampleStore(2, active: false)];
  final queries = <StoreQuery>[];
  final opened = <String>[];
  Result<StoreDetails>? detailsResult;
  final updates = <(String, EditedStore)>[];
  Result<StoreDetails>? updateResult;

  /// Bookings waiting end after the hours saved close the store: saving
  /// fails until it says to cancel them.
  bool hoursCutBookings = false;

  /// The stores saved with their bookings cancelled.
  final cancelledByHours = <String>[];
  final activeChanges = <(String, bool)>[];
  Result<StoreDetails>? setActiveResult;
  Result<StoreOngoing> ongoingResult = const Ok(
    StoreOngoing(liveOffers: 0, openBookings: 0),
  );
  final imageUploads = <(String, StoreImage, PreparedPhoto)>[];
  final removedImages = <(String, StoreImage)>[];
  Result<StoreDetails>? removeImageResult;
  final deleted = <String>[];
  Result<void> deleteResult = const Ok(null);
  final resolvedLinks = <String>[];
  Result<LatLng> locationResult = const Ok((
    latitude: 32.8872,
    longitude: 13.1913,
  ));
  final created = <NewStore>[];
  Result<CreatedStore>? createResult;
  final addedLocations = <(String, NewLocation)>[];
  Result<StoreDetails>? addLocationResult;

  @override
  Future<Result<StorePage>> list(StoreQuery query) async {
    queries.add(query);
    final matching = [
      for (final store in stores)
        if (store.name.toLowerCase().contains(query.search.toLowerCase()))
          store,
    ];
    return Ok(StorePage(items: matching, total: matching.length));
  }

  @override
  Future<Result<StoreDetails>> get(String id) async {
    opened.add(id);
    return detailsResult ?? Ok(sampleDetails(id));
  }

  @override
  Future<Result<StoreDetails>> update(
    String id,
    EditedStore store, {
    bool cancelBookings = false,
  }) async {
    updates.add((id, store));
    if (hoursCutBookings && !cancelBookings) {
      return const Err(
        ConflictFailure(
          'Some bookings end after these hours close the store.',
          StoreCodes.hoursCancelBookings,
        ),
      );
    }
    if (cancelBookings) cancelledByHours.add(id);
    final saved = sampleDetails(id);
    final place = store.place;
    return updateResult ??
        Ok(
          StoreDetails(
            id: id,
            name: store.name,
            category: sampleCategory,
            isActive: true,
            missingToGoLive: const [],
            createdAt: saved.createdAt,
            city: place?.city ?? saved.city,
            area: place?.area ?? saved.area,
            address: place == null ? saved.address : place.address,
            latitude: place?.latitude ?? saved.latitude,
            longitude: place?.longitude ?? saved.longitude,
            openingHours: place?.openingHours ?? saved.openingHours,
            teamCount: 3,
            ratingCount: 0,
            pickupInstructions: store.pickupInstructions,
            phone: store.phone,
            email: store.email,
            facebookUrl: store.facebookUrl,
            instagramUrl: store.instagramUrl,
          ),
        );
  }

  @override
  Future<Result<StoreDetails>> setActive(
    String id, {
    required bool active,
  }) async {
    activeChanges.add((id, active));
    return setActiveResult ?? Ok(sampleDetails(id, active: active));
  }

  @override
  Future<Result<StoreOngoing>> ongoing(String id) async => ongoingResult;

  Result<int> cancelBookingsResult = const Ok(0);
  final bookingsCancelled = <String>[];

  @override
  Future<Result<int>> cancelBookings(String id) async {
    bookingsCancelled.add(id);
    return cancelBookingsResult;
  }

  /// The store with the new photo, the other one as [detailsResult] had it.
  @override
  Future<Result<StoreDetails>> setImage(
    String id,
    StoreImage image,
    PreparedPhoto photo, {
    required void Function(double sent) onProgress,
  }) async {
    imageUploads.add((id, image, photo));
    onProgress(1);
    final store = detailsResult?.valueOrNull ?? sampleDetails(id);
    return Ok(
      _withImages(
        store,
        logoUrl: image == StoreImage.logo
            ? 'https://img.test/logo.jpg'
            : store.logoUrl,
        coverUrl: image == StoreImage.cover
            ? 'https://img.test/cover.jpg'
            : store.coverUrl,
      ),
    );
  }

  @override
  Future<Result<StoreDetails>> removeImage(String id, StoreImage image) async {
    removedImages.add((id, image));
    if (removeImageResult case final result?) return result;
    final store = detailsResult?.valueOrNull ?? sampleDetails(id);
    return Ok(
      _withImages(
        store,
        logoUrl: image == StoreImage.logo ? null : store.logoUrl,
        coverUrl: image == StoreImage.cover ? null : store.coverUrl,
      ),
    );
  }

  @override
  Future<Result<void>> delete(String id) async {
    deleted.add(id);
    return deleteResult;
  }

  @override
  Future<Result<LatLng>> resolveLocation(String link) async {
    resolvedLinks.add(link);
    return locationResult;
  }

  @override
  Future<Result<List<Category>>> categories() async =>
      const Ok([sampleCategory]);

  @override
  Future<Result<CreatedStore>> create(NewStore store) async {
    created.add(store);
    return createResult ??
        Ok(
          CreatedStore(
            storeId: 'new',
            storeName: store.name,
            ownerPhone: store.ownerPhone,
            temporaryPassword: 'Tmp-4821-xk',
          ),
        );
  }

  @override
  Future<Result<StoreDetails>> addLocation(
    String storeId,
    NewLocation location,
  ) async {
    addedLocations.add((storeId, location));
    final place = location.place;
    final brand = sampleDetails(storeId);
    return addLocationResult ??
        Ok(
          StoreDetails(
            id: 'store-new',
            name: brand.name,
            category: brand.category,
            // Off until our team has checked it.
            isActive: false,
            missingToGoLive: const [],
            createdAt: DateTime.utc(2026, 11, 10, 12),
            city: place.city,
            area: place.area,
            address: place.address,
            latitude: place.latitude,
            longitude: place.longitude,
            openingHours: place.openingHours,
            teamCount: 1,
            ratingCount: 0,
            phone: location.phone ?? brand.phone,
          ),
        );
  }
}

DashboardUser sampleUser(
  int n, {
  DashboardRole role = DashboardRole.editor,
  bool active = true,
}) => DashboardUser(
  id: 'user-$n',
  name: 'User $n',
  email: 'user$n@offers.ly',
  role: role,
  isActive: active,
  createdAt: DateTime.utc(2026, 10, n, 12),
  lastLoginAt: n == 1 ? DateTime.utc(2026, 10, 20, 12) : null,
);

class FakeDashboardUserRepository implements DashboardUserRepository {
  List<DashboardUser> users = [
    sampleUser(1, role: DashboardRole.admin),
    sampleUser(2, active: false),
  ];
  final queries = <DashboardUserQuery>[];
  final created = <NewDashboardUser>[];
  Result<CreatedDashboardUser>? createResult;
  final opened = <String>[];
  final updates = <(String, EditedDashboardUser)>[];
  final activeChanges = <(String, bool)>[];
  final resets = <String>[];

  DashboardUser _find(String id) =>
      users.firstWhere((user) => user.id == id, orElse: () => sampleUser(9));

  @override
  Future<Result<DashboardUser>> get(String id) async {
    opened.add(id);
    return Ok(_find(id));
  }

  @override
  Future<Result<DashboardUser>> update(
    String id,
    EditedDashboardUser user,
  ) async {
    updates.add((id, user));
    final saved = _find(id);
    return Ok(
      DashboardUser(
        id: id,
        name: user.name,
        email: saved.email,
        role: user.role,
        isActive: saved.isActive,
        createdAt: saved.createdAt,
        lastLoginAt: saved.lastLoginAt,
      ),
    );
  }

  @override
  Future<Result<DashboardUser>> setActive(
    String id, {
    required bool active,
  }) async {
    activeChanges.add((id, active));
    final saved = _find(id);
    return Ok(
      DashboardUser(
        id: id,
        name: saved.name,
        email: saved.email,
        role: saved.role,
        isActive: active,
        createdAt: saved.createdAt,
        lastLoginAt: saved.lastLoginAt,
      ),
    );
  }

  @override
  Future<Result<String>> resetPassword(String id) async {
    resets.add(id);
    return const Ok('Tmp-5521-hw');
  }

  @override
  Future<Result<DashboardUserPage>> list(DashboardUserQuery query) async {
    queries.add(query);
    final matching = [
      for (final user in users)
        if (query.filter == null || user.role == query.filter) user,
    ];
    return Ok(DashboardUserPage(items: matching, total: matching.length));
  }

  @override
  Future<Result<CreatedDashboardUser>> create(NewDashboardUser user) async {
    created.add(user);
    return createResult ??
        Ok(
          CreatedDashboardUser(
            user: DashboardUser(
              id: 'new',
              name: user.name,
              email: user.email,
              role: user.role,
              isActive: true,
              createdAt: DateTime.utc(2026, 10, 22, 12),
            ),
            temporaryPassword: 'Tmp-7310-qz',
          ),
        );
  }
}

class FakePlatformSettingsRepository implements PlatformSettingsRepository {
  PlatformSettings saved = const PlatformSettings(
    browseRadiusKm: 25,
    holdMinutes: 120,
  );
  final updates = <PlatformSettings>[];

  @override
  Future<Result<PlatformSettings>> get() async => Ok(saved);

  @override
  Future<Result<PlatformSettings>> update(PlatformSettings settings) async {
    updates.add(settings);
    return Ok(saved = settings);
  }
}

const tripoliArea = ServiceArea(
  id: 'a1',
  nameAr: 'طرابلس',
  nameEn: 'Tripoli',
  latitude: 32.85,
  longitude: 13.18,
  radiusKm: 30,
  isActive: true,
);

class FakeServiceAreaRepository implements ServiceAreaRepository {
  var areas = <ServiceArea>[tripoliArea];
  final created = <ServiceAreaDraft>[];
  final updated = <(String, ServiceAreaDraft)>[];
  final deleted = <String>[];

  @override
  Future<Result<List<ServiceArea>>> list() async => Ok(areas);

  @override
  Future<Result<ServiceArea>> create(ServiceAreaDraft draft) async {
    created.add(draft);
    final area = _area('a${areas.length + 1}', draft);
    areas = [...areas, area];
    return Ok(area);
  }

  @override
  Future<Result<ServiceArea>> update(String id, ServiceAreaDraft draft) async {
    updated.add((id, draft));
    final area = _area(id, draft);
    areas = [for (final a in areas) a.id == id ? area : a];
    return Ok(area);
  }

  @override
  Future<Result<void>> delete(String id) async {
    deleted.add(id);
    areas = [
      for (final a in areas)
        if (a.id != id) a,
    ];
    return const Ok(null);
  }

  static ServiceArea _area(String id, ServiceAreaDraft draft) => ServiceArea(
    id: id,
    nameAr: draft.nameAr,
    nameEn: draft.nameEn,
    latitude: draft.latitude,
    longitude: draft.longitude,
    radiusKm: draft.radiusKm,
    isActive: draft.isActive,
  );
}

/// The app language, fixed to English so it matches the screens under test.
class EnglishLocale extends LocaleController {
  @override
  Locale build() => const Locale('en');
}

class FakeSearchTermRepository implements SearchTermRepository {
  List<SearchTerm> terms = [
    SearchTerm(
      query: 'كيك',
      searchCount: 12,
      lastResultCount: 4,
      lastSearchedAt: DateTime.utc(2026, 11, 8),
    ),
    SearchTerm(
      query: 'بازين',
      searchCount: 3,
      lastResultCount: 0,
      lastSearchedAt: DateTime.utc(2026, 11, 7),
    ),
  ];
  final queries = <SearchTermQuery>[];

  @override
  Future<Result<SearchTermPage>> list(SearchTermQuery query) async {
    queries.add(query);
    final shown = [
      for (final term in terms)
        if (switch (query.filter) {
          null => true,
          SearchTermFilter.nothingFound => term.lastResultCount == 0,
          SearchTermFilter.found => term.lastResultCount > 0,
        })
          term,
    ];
    return Ok(SearchTermPage(total: shown.length, items: shown));
  }
}

ActivityEntry sampleActivity({
  String id = 'a1',
  String action = 'store.update',
  String? actorName = 'Sara',
  String? targetLabel = 'Pizza Corner',
  List<ActivityChange> changes = const [
    ActivityChange(field: 'name', value: 'Pizza Corner'),
    ActivityChange(field: 'phone', value: null),
  ],
}) => ActivityEntry(
  id: id,
  action: action,
  actorName: actorName,
  targetLabel: targetLabel,
  changes: changes,
  requestId: 'req-42',
  createdAt: DateTime.utc(2026, 11, 9, 10),
);

class FakeActivityRepository implements ActivityRepository {
  List<ActivityEntry> entries = [
    sampleActivity(),
    sampleActivity(
      id: 'a2',
      action: 'job.run',
      actorName: null,
      targetLabel: 'expire-claims',
      changes: const [],
    ),
  ];
  final queries = <ActivityQuery>[];

  @override
  Future<Result<ActivityPage>> list(ActivityQuery query) async {
    queries.add(query);
    final shown = [
      for (final entry in entries)
        if (switch (query.filter) {
          null => true,
          ActivityArea.stores => entry.action.startsWith('store.'),
          ActivityArea.jobs => entry.action.startsWith('job.'),
          _ => false,
        })
          entry,
    ];
    return Ok(ActivityPage(total: shown.length, items: shown));
  }
}

/// A missed pickup of 2 reported because the store was closed; its
/// customer was paused when [paused].
CustomerReport sampleReport({
  String id = 'r1',
  ReportReason reason = ReportReason.storeClosed,
  String? note = 'The door was locked at 8:30',
  ReportState state = ReportState.open,
  bool hasStrike = true,
  bool paused = false,
  bool strikeRemoved = false,
  String? resolution,
}) => CustomerReport(
  id: id,
  reason: reason,
  note: note,
  state: state,
  createdAt: DateTime.utc(2026, 11, 9, 19),
  booking: ReportedBooking(
    id: 'c-$id',
    code: 'K7Q2',
    status: ReportedBookingStatus.missed,
    quantity: 2,
    totalPrice: '9.000',
    offerTitle: 'Kunafa box',
    createdAt: DateTime.utc(2026, 11, 9, 18),
    expiresAt: DateTime.utc(2026, 11, 9, 18, 30),
  ),
  store: const ReportedStore(id: 's1', name: 'Sweet Corner', area: 'Andalus'),
  customer: ReportCustomer(
    id: 'u-$id',
    name: 'Huda',
    email: 'huda@example.com',
    contactPhone: '+218910000001',
    missedPickups: hasStrike ? 3 : 2,
    pausedUntil: paused ? DateTime.utc(2026, 11, 12, 18, 30) : null,
  ),
  hasStrike: hasStrike,
  strikeRemoved: strikeRemoved,
  pauseEnded: false,
  resolution: resolution,
  resolvedAt: state == ReportState.resolved
      ? DateTime.utc(2026, 11, 10, 9)
      : null,
  resolverName: state == ReportState.resolved ? 'Sara' : null,
);

class FakeReportRepository implements ReportRepository {
  List<CustomerReport> reports = [
    sampleReport(paused: true),
    sampleReport(
      id: 'r2',
      reason: ReportReason.quality,
      note: null,
      state: ReportState.resolved,
      strikeRemoved: true,
      resolution: 'The store owned up',
    ),
  ];
  final queries = <ReportQuery>[];
  final resolved = <(String, ReportResolution)>[];

  /// What resolving answers; by default, the report as resolved.
  Result<CustomerReport>? resolveResult;

  @override
  Future<Result<ReportPage>> list(ReportQuery query) async {
    queries.add(query);
    final shown = [
      for (final report in reports)
        if (query.filter == null || report.state == query.filter) report,
    ];
    return Ok(ReportPage(total: shown.length, items: shown));
  }

  @override
  Future<Result<CustomerReport>> resolve(
    String id,
    ReportResolution resolution,
  ) async {
    resolved.add((id, resolution));
    final result = resolveResult;
    if (result != null) return result;
    final report = sampleReport(
      id: id,
      state: ReportState.resolved,
      hasStrike: !resolution.removeStrike,
      strikeRemoved: resolution.removeStrike,
      resolution: resolution.note,
    );
    reports = [
      for (final r in reports)
        if (r.id == id) report else r,
    ];
    return Ok(report);
  }
}

final sampleInstance = SystemInstance(
  id: 'i1',
  hostname: 'api-1',
  version: '1.4.0',
  nodeVersion: 'v24.11.0',
  startedAt: DateTime.utc(2026, 11, 7, 9),
  reportedAt: DateTime.utc(2026, 11, 9, 12),
  uptime: const Duration(days: 2, hours: 3),
  memoryBytes: 180 * 1024 * 1024,
  heapBytes: 90 * 1024 * 1024,
  cpuPercent: 12.5,
  eventLoopDelayMs: 21,
  connections: 4,
  idleConnections: 3,
  waitingForConnection: 0,
  maxConnections: 10,
  requestsPerMinute: 42,
  current: true,
);

SystemOverview sampleOverview({
  ServiceHealth redis = ServiceHealth.up,
  int failingJobs = 0,
  int serverErrors = 0,
}) => SystemOverview(
  checkedAt: DateTime.utc(2026, 11, 9, 12),
  database: const ServiceCheck(health: ServiceHealth.up, latencyMs: 2),
  redis: ServiceCheck(
    health: redis,
    latencyMs: redis == ServiceHealth.up ? 1 : null,
    detail: redis == ServiceHealth.down ? 'Connection refused' : null,
  ),
  instances: [sampleInstance],
  requestsPerMinute: 42,
  serverErrors: serverErrors,
  errorRate: serverErrors / 210,
  p95Ms: 85,
  jobs: 2,
  failingJobs: failingJobs,
  runningJobs: 0,
  errorGroups: serverErrors == 0 ? 0 : 1,
);

final sampleTraffic = SystemTraffic(
  minutes: [
    for (var n = 0; n < 15; n++)
      TrafficMinute(
        at: DateTime.utc(2026, 11, 9, 11, 45 + n),
        requests: 40 + n,
        serverErrors: n == 14 ? 1 : 0,
        p95Ms: 80,
      ),
  ],
  routes: const [
    RouteTraffic(
      method: 'GET',
      route: '/api/v1/offers',
      requests: 520,
      clientErrors: 0,
      serverErrors: 1,
      p50Ms: 12,
      p95Ms: 85,
      p99Ms: 140,
    ),
  ],
);

final sampleError = SystemError(
  name: 'TypeError',
  message: 'Cannot read properties of undefined',
  method: 'GET',
  route: '/api/v1/offers',
  statusCode: 500,
  count: 3,
  firstSeenAt: DateTime.utc(2026, 11, 9, 8),
  lastSeenAt: DateTime.utc(2026, 11, 9, 11, 59),
  lastRequestId: 'req-42',
  stack: 'TypeError: Cannot read properties of undefined\n    at browse',
  instances: 1,
);

SystemJob sampleJob({
  String name = 'expire-claims',
  JobOutcome? outcome = JobOutcome.succeeded,
  bool running = false,
  int runs = 12,
}) => SystemJob(
  name: name,
  description: 'Expires reservations',
  schedule: '* * * * *',
  nextRunAt: DateTime.utc(2026, 11, 9, 12, 1),
  running: running,
  lastStartedAt: outcome == null ? null : DateTime.utc(2026, 11, 9, 12),
  lastDuration: outcome == null ? null : const Duration(milliseconds: 35),
  lastOutcome: outcome,
  lastResult: outcome == null ? const {} : const {'expired': 2},
  lastError: outcome == JobOutcome.failed ? 'Database went away' : null,
  runs: runs,
  failures: outcome == JobOutcome.failed ? 1 : 0,
  backlog: 0,
  backlogLabel: 'Reservations past their time',
);

const sampleDatabase = DatabaseStats(
  version: '18.1',
  sizeBytes: 48 * 1024 * 1024,
  connections: 6,
  activeConnections: 1,
  idleInTransaction: 0,
  waitingOnLocks: 0,
  maxConnections: 100,
  cacheHitRatio: 0.995,
  statementsAvailable: false,
  slowestQueries: [],
  running: [],
  tables: [
    DatabaseTable(
      name: 'offers',
      rows: 1200,
      bytes: 2 * 1024 * 1024,
      deadRows: 4,
    ),
  ],
);

class FakeSystemRepository implements SystemRepository {
  Result<SystemOverview> overviewResult = Ok(sampleOverview());
  var overviewCalls = 0;
  Result<SystemTraffic> trafficResult = Ok(sampleTraffic);
  final trafficWindows = <int>[];
  Result<List<SystemError>> errorsResult = Ok([sampleError]);
  Result<List<SystemJob>> jobsResult = Ok([
    sampleJob(),
    sampleJob(name: 'clean-refresh-tokens', outcome: null, runs: 0),
  ]);
  Result<SystemJob>? runResult;
  final ran = <String>[];
  Result<DatabaseStats> databaseResult = const Ok(sampleDatabase);

  @override
  Future<Result<SystemOverview>> overview() async {
    overviewCalls++;
    return overviewResult;
  }

  @override
  Future<Result<SystemTraffic>> traffic({required int minutes}) async {
    trafficWindows.add(minutes);
    return trafficResult;
  }

  @override
  Future<Result<List<SystemError>>> errors() async => errorsResult;

  @override
  Future<Result<List<SystemJob>>> jobs() async => jobsResult;

  @override
  Future<Result<SystemJob>> runJob(String name) async {
    ran.add(name);
    return runResult ?? Ok(sampleJob(name: name, runs: 13));
  }

  @override
  Future<Result<DatabaseStats>> database() async => databaseResult;
}

/// [store] with these photos, made the way [sampleDetails] makes it.
StoreDetails _withImages(
  StoreDetails store, {
  required String? logoUrl,
  required String? coverUrl,
}) => sampleDetails(
  store.id,
  active: store.isActive,
  missing: store.missingToGoLive,
  logoUrl: logoUrl,
  coverUrl: coverUrl,
);
