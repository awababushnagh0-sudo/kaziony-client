import 'package:kernel/kernel.dart' show normalizeLibyanPhone;
import 'package:reactive_forms/reactive_forms.dart';

abstract final class SValidators {
  static const libyanPhoneKey = 'libyanPhone';
  static const urlKey = 'url';

  /// Any common Libyan mobile format (0912345678, +218 91..., Arabic digits).
  static const Validator<dynamic> libyanPhone = _LibyanPhoneValidator();

  /// An email address. Spaces around it are ignored (pasted text), so
  /// trim the value before sending it.
  static const Validator<dynamic> email = _EmailValidator();

  /// A web link (http or https) to a real host, like the backend accepts.
  /// Spaces around it are ignored, so trim the value before sending it.
  static const Validator<dynamic> url = _UrlValidator();
}

class _EmailValidator extends Validator<dynamic> {
  const _EmailValidator();

  static final _pattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    if (value is! String || value.trim().isEmpty) return null;
    return _pattern.hasMatch(value.trim())
        ? null
        : {ValidationMessage.email: true};
  }
}

class _UrlValidator extends Validator<dynamic> {
  const _UrlValidator();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    if (value is! String || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    final valid =
        uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.contains('.') &&
        !uri.host.endsWith('.');
    return valid ? null : {SValidators.urlKey: true};
  }
}

class _LibyanPhoneValidator extends Validator<dynamic> {
  const _LibyanPhoneValidator();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    if (value is! String || value.isEmpty) return null;
    return normalizeLibyanPhone(value) == null
        ? {SValidators.libyanPhoneKey: true}
        : null;
  }
}
