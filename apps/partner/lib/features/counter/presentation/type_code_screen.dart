import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/routes/routes.dart';
import '../domain/claim.dart';

/// For a QR code that won't scan (a cracked or dim screen): the customer
/// reads out the 8 characters under it.
class TypeCodeScreen extends AppStatefulView {
  const TypeCodeScreen({super.key});

  @override
  AppViewState<TypeCodeScreen> createState() => _TypeCodeScreenState();
}

class _TypeCodeScreenState extends AppViewState<TypeCodeScreen> {
  final _form = FormGroup({
    'code': FormControl<String>(
      validators: [Validators.required, const _IsClaimCode()],
    ),
  });

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _check() {
    if (_form.invalid) {
      _form.markAllAsTouched();
      return;
    }
    final code = ClaimCode.read(_form.control('code').value as String);
    if (code != null) context.pushReplacement(Routes.claim(code));
  }

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return SScaffold(
      title: s.typeCode,
      scrollable: true,
      bottom: SButton(label: s.checkCode, onPressed: _check, expand: true),
      body: SForm(
        form: _form,
        child: STextInput(
          controlName: 'code',
          label: s.codeLabel,
          kind: TextInputKind.code,
          helper: s.codeHelper,
          maxLength: ClaimCode.length,
          autofocus: true,
          isLast: true,
          onSubmitted: _check,
          validationMessages: {_IsClaimCode.key: (_) => s.codeInvalid},
        ),
      ),
    );
  }
}

class _IsClaimCode extends Validator<dynamic> {
  const _IsClaimCode();

  static const key = 'claimCode';

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    // An empty field is Validators.required's to report.
    if (value is! String || value.isEmpty) return null;
    return ClaimCode.read(value) == null ? {key: true} : null;
  }
}
