import 'dart:async';

import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../../../core/widgets/partner_illustrations.dart';
import '../domain/claim.dart';

/// For a QR code that won't scan (a cracked or dim screen): the customer
/// reads out the 8 characters under it.
class TypeCodeScreen extends AppStatefulView {
  const TypeCodeScreen({super.key});

  @override
  AppViewState<TypeCodeScreen> createState() => _TypeCodeScreenState();
}

class _TypeCodeScreenState extends AppViewState<TypeCodeScreen> {
  final _form = FormGroup({'code': FormControl<String>()});
  late final StreamSubscription<Object?> _typed;

  /// Only characters a code can have get typed, so a full one is a code.
  String? get _code =>
      ClaimCode.read(_form.control('code').value as String? ?? '');

  @override
  void initState() {
    super.initState();
    _typed = _form.control('code').valueChanges.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    unawaited(_typed.cancel());
    _form.dispose();
    super.dispose();
  }

  void _check() {
    if (_code case final code?) context.pushReplacement(Routes.claim(code));
  }

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return SScaffold(
      title: s.typeCode,
      scrollable: true,
      body: SForm(
        form: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(Space.xl),
            const Center(child: SIllustration(PartnerIllustrations.typeCode)),
            const Gap(Space.md),
            SText(
              s.codeHelper,
              color: SColor.textMuted,
              align: TextAlign.center,
            ),
            const Gap(Space.xl),
            SCodeInput(
              controlName: 'code',
              label: s.codeLabel,
              length: ClaimCode.length,
              characters: ClaimCode.character,
              autofocus: true,
              onSubmitted: _check,
            ),
            const Gap(Space.xl),
            SButton(
              label: s.checkCode,
              expand: true,
              onPressed: _code == null ? null : _check,
            ),
          ],
        ),
      ),
    );
  }
}
