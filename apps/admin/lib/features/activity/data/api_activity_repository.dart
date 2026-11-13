import 'package:kernel/kernel.dart';
import 'package:offers_api/admin.dart';

import '../domain/activity_entry.dart';

class ApiActivityRepository implements ActivityRepository {
  ApiActivityRepository(this._api);

  final Api _api;
  late final _log = _api.client(AdminAuditLogClient.new);

  @override
  Future<Result<ActivityPage>> list(ActivityQuery query) async {
    final result = await _api.guard(
      () => _log.list(
        page: query.page,
        pageSize: query.pageSize,
        search: query.search.isEmpty ? null : query.search,
        area: switch (query.filter) {
          null => null,
          ActivityArea.stores => AuditArea.store,
          ActivityArea.users => AuditArea.user,
          ActivityArea.categories => AuditArea.category,
          ActivityArea.serviceAreas => AuditArea.serviceArea,
          ActivityArea.settings => AuditArea.settings,
          ActivityArea.offers => AuditArea.offer,
          ActivityArea.reports => AuditArea.report,
          ActivityArea.jobs => AuditArea.job,
        },
      ),
    );
    return result.map(
      (dto) => ActivityPage(
        total: dto.meta.total.toInt(),
        items: [for (final entry in dto.items) _toEntry(entry)],
      ),
    );
  }
}

ActivityEntry _toEntry(AuditEntryDto dto) => ActivityEntry(
  id: dto.id,
  action: dto.action,
  actorName: dto.actor?.name ?? dto.actor?.email,
  targetLabel: dto.targetLabel,
  changes: [
    for (final change in dto.changes)
      ActivityChange(field: change.field, value: change.value),
  ],
  requestId: dto.requestId,
  createdAt: dto.createdAt,
);
