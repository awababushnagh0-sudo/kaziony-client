import 'package:flutter/widgets.dart' show Text;
import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';

void main() {
  testWidgets('failed view models are not retried automatically', (
    tester,
  ) async {
    var calls = 0;
    final failing = FutureProvider.autoDispose<int>((ref) async {
      calls++;
      throw StateError('offline');
    });

    await tester.pumpWidget(
      AppScope(
        child: AppConsumer(
          builder: (context, ref) => Text(
            ref.watch(failing) is AsyncError ? 'error' : 'loading',
            textDirection: TextDirection.ltr,
          ),
        ),
      ),
    );
    // Riverpod's default would retry with back-off for over a minute.
    await tester.pump(const Duration(minutes: 2));

    expect(find.text('error'), findsOneWidget);
    expect(calls, 1);
  });
}
