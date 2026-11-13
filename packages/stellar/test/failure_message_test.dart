import 'package:flutter_test/flutter_test.dart';
import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

/// What [failureMessage] says for [failure], in [language], with the app's
/// [wording].
Future<String> messageFor(
  WidgetTester tester,
  AppFailure failure, {
  String language = 'en',
  FailureWording? wording,
}) async {
  late String message;
  await tester.pumpWidget(
    SApp(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) {
              message = failureMessage(context, failure);
              return const SizedBox();
            },
          ),
        ],
      ),
      locale: Locale(language),
      onGenerateTitle: (_) => 'test',
      failureWording: wording,
    ),
  );
  await tester.pumpAndSettle();
  return message;
}

void main() {
  const conflict = ConflictFailure('Only active reservations', 'NotOneOfOurs');

  testWidgets("shows a conflict's own words to someone reading English", (
    tester,
  ) async {
    expect(await messageFor(tester, conflict), 'Only active reservations');
  });

  testWidgets("never shows the server's English in Arabic", (tester) async {
    expect(
      await messageFor(tester, conflict, language: 'ar'),
      'لا يمكن إتمام هذا الآن.',
    );
  });

  testWidgets("says it in the app's words when it has some", (tester) async {
    String? wording(BuildContext context, AppFailure failure) =>
        switch (failure) {
          ConflictFailure(code: 'NotOneOfOurs') => 'In our words',
          _ => null,
        };

    expect(
      await messageFor(tester, conflict, language: 'ar', wording: wording),
      'In our words',
    );
    // The rest as usual.
    expect(
      await messageFor(tester, const NoConnectionFailure(), wording: wording),
      isNot('In our words'),
    );
  });
}
