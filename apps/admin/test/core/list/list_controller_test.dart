import 'package:admin/core/list/list_controller.dart';
import 'package:admin/core/list/list_query.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

enum Status { on, off }

final queryProvider =
    NotifierProvider.autoDispose<ListController<Status>, ListQuery<Status>>(
      ListController.new,
    );

void main() {
  late ProviderContainer container;
  ListQuery<Status> query() => container.read(queryProvider);
  ListController<Status> controller() => container.read(queryProvider.notifier);

  setUp(() {
    container = ProviderContainer();
    // Keeps the auto-dispose provider alive between reads.
    container.listen(queryProvider, (_, _) {});
  });
  tearDown(() => container.dispose());

  test('starts on page 1 with no search or filter', () {
    expect(query(), const ListQuery<Status>());
    expect(query().hasFilters, isFalse);
  });

  testWidgets('searches after a pause in typing, from page 1', (tester) async {
    controller()
      ..nextPage()
      ..setSearch('ca')
      ..setSearch(' cafe ');
    await tester.pump(ListController.searchDelay ~/ 2);
    expect(query().search, '');

    await tester.pump(ListController.searchDelay);
    expect(query().search, 'cafe');
    expect(query().page, 1);
    expect(query().hasFilters, isTrue);
  });

  test('a new filter or page size goes back to page 1', () {
    controller()
      ..nextPage()
      ..nextPage()
      ..setFilter(Status.off);
    expect((query().filter, query().page), (Status.off, 1));

    controller()
      ..nextPage()
      ..setPageSize(50);
    expect((query().pageSize, query().page), (50, 1));

    // Back to all, keeping the page size.
    controller().setFilter(null);
    expect((query().filter, query().pageSize), (null, 50));
  });

  test('never goes before page 1', () {
    controller().previousPage();
    expect(query().page, 1);
  });

  test('counts pages, at least one', () {
    const empty = PageResult<int>(items: [], total: 0);
    const some = PageResult<int>(items: [1], total: 41);
    expect(empty.pageCount(20), 1);
    expect(some.pageCount(20), 3);
    expect(some.pageCount(50), 1);
  });
}
