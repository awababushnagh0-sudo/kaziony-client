import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:partner/core/list/paged_list_view_model.dart';

/// Rows "0" to "[total] - 1", served a page at a time.
class _Numbers extends PagedListViewModel<String, String> {
  static var total = 45;
  static AppFailure? failNext;
  static final pages = <int>[];

  @override
  String watchQuery() => '';

  @override
  Future<Result<PageResult<String>>> fetch(
    String query, {
    required int page,
  }) async {
    pages.add(page);
    if (failNext case final failure?) {
      failNext = null;
      return Err(failure);
    }
    const size = PagedListViewModel.pageSize;
    final start = (page - 1) * size;
    return Ok(
      PageResult(
        items: [for (var i = start; i < total && i < start + size; i++) '$i'],
        total: total,
      ),
    );
  }
}

final _numbers = AsyncNotifierProvider<_Numbers, PagedItems<String>>(
  _Numbers.new,
);

void main() {
  late ProviderContainer container;

  setUp(() {
    _Numbers.total = 45;
    _Numbers.failNext = null;
    _Numbers.pages.clear();
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  Future<PagedItems<String>> first() => container.read(_numbers.future);
  _Numbers viewModel() => container.read(_numbers.notifier);
  PagedItems<String> items() => container.read(_numbers).requireValue;

  test('loads the first page, then more until all are there', () async {
    expect((await first()).items, hasLength(20));
    expect(items().hasMore, isTrue);

    await viewModel().loadMore();
    await viewModel().loadMore();
    expect(items().items, hasLength(45));
    expect(items().items.last, '44');
    expect(items().hasMore, isFalse);

    // Nothing left to load.
    await viewModel().loadMore();
    expect(_Numbers.pages, [1, 2, 3]);
  });

  test('keeps the rows when more fail to load, and retries', () async {
    await first();
    _Numbers.failNext = const NoConnectionFailure();
    await viewModel().loadMore();
    expect(items().items, hasLength(20));
    expect(items().moreFailure, isA<NoConnectionFailure>());

    await viewModel().loadMore();
    expect(items().items, hasLength(40));
    expect(items().moreFailure, isNull);
  });

  test('refreshing starts over and keeps the rows if it fails', () async {
    await first();
    await viewModel().loadMore();
    _Numbers.total = 3;
    expect(await viewModel().refresh(), isNull);
    expect(items().items, ['0', '1', '2']);

    _Numbers.failNext = const NoConnectionFailure();
    expect(await viewModel().refresh(), isA<NoConnectionFailure>());
    expect(items().items, ['0', '1', '2']);
  });
}
