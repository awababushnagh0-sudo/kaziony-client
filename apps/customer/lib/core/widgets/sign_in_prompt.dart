import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../l10n/generated/customer_localizations.dart';
import '../routes/routes.dart';
import 'customer_illustrations.dart';

/// What a guest sees wherever an account is needed, the same everywhere:
/// the guest picture, why to sign in, and the button to the sign-in page.
/// In a page or a tab it's shown in place ([SignInPrompt.new]); after an
/// action that needs an account (reserving) it slides up in a sheet
/// ([SignInPrompt.show]).
class SignInPrompt extends StatelessWidget {
  /// [title] and [message] say why here; by default, the guest's welcome.
  const SignInPrompt({this.title, this.message, super.key});

  final String? title;
  final String? message;

  /// The prompt in a sheet; its button closes the sheet and opens the
  /// sign-in page, which comes back here once signed in.
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
  }) => SSheet.show<void>(
    context,
    title: title,
    subtitle: message,
    illustration: CustomerIllustrations.guest,
    builder: (sheet) => SButton(
      label: CustomerLocalizations.of(context).signInAction,
      expand: true,
      onPressed: () {
        Navigator.of(sheet).pop();
        context.push(Routes.signIn);
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final s = CustomerLocalizations.of(context);
    return SEmptyView(
      illustration: CustomerIllustrations.guest,
      title: title ?? s.guestTitle,
      message: message ?? s.guestMessage,
      actionLabel: s.signInAction,
      onAction: () => context.push(Routes.signIn),
    );
  }
}
