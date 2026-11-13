import 'package:kernel/kernel.dart';

import '../../../core/list/list_controller.dart';
import '../domain/customer.dart';

/// The customers list's search, standing filter and page.
final customerQueryProvider =
    NotifierProvider.autoDispose<
      ListController<CustomerStanding>,
      CustomerQuery
    >(ListController.new);

/// The current page of customers.
final customerPageProvider = FutureProvider.autoDispose<CustomerPage>(
  (ref) => loadPage(
    ref.watch(customerRepositoryProvider).list,
    ref.watch(customerQueryProvider),
  ),
);
