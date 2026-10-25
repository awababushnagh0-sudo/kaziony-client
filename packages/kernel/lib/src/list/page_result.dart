/// One page of a list, and how many rows match on all pages.
class PageResult<T> {
  const PageResult({required this.items, required this.total});

  final List<T> items;
  final int total;

  /// At least 1, so an empty list still reads "page 1 of 1".
  int pageCount(int pageSize) => total == 0 ? 1 : (total / pageSize).ceil();
}
