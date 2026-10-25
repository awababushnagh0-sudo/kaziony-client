/// What a dashboard list shows: the search, one filter, and the page.
///
/// [F] is the list's filter (a status, a category id, ...); null shows
/// everything.
class ListQuery<F> {
  const ListQuery({
    this.search = '',
    this.filter,
    this.page = 1,
    this.pageSize = 20,
  });

  static const pageSizes = [20, 50, 100];

  final String search;
  final F? filter;
  final int page;
  final int pageSize;

  /// Whether the user narrowed the list (an empty list then means "no
  /// matches", not "nothing yet").
  bool get hasFilters => search.isNotEmpty || filter != null;

  ListQuery<F> copyWith({String? search, int? page, int? pageSize}) =>
      ListQuery(
        search: search ?? this.search,
        filter: filter,
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
      );

  /// Another filter (null for all), back on the first page.
  ListQuery<F> withFilter(F? filter) =>
      ListQuery(search: search, filter: filter, pageSize: pageSize);

  @override
  bool operator ==(Object other) =>
      other is ListQuery<F> &&
      other.search == search &&
      other.filter == filter &&
      other.page == page &&
      other.pageSize == pageSize;

  @override
  int get hashCode => Object.hash(search, filter, page, pageSize);
}
