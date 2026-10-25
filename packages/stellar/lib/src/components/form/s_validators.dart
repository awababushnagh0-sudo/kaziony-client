import 'package:kernel/kernel.dart' show normalizeLibyanPhone, parsePrice;
import 'package:reactive_forms/reactive_forms.dart';

abstract final class SValidators {
  static const libyanPhoneKey = 'libyanPhone';
  static const urlKey = 'url';
  static const priceKey = 'price';
  static const wholeNumberKey = 'wholeNumber';

  /// Any common Libyan mobile format (0912345678, +218 91..., Arabic digits).
  static const Validator<dynamic> libyanPhone = _LibyanPhoneValidator();

  /// An email address. Spaces around it are ignored (pasted text), so
  /// trim the value before sending it.
  static const Validator<dynamic> email = _EmailValidator();

  /// A web link (http or https) to a real host, like the backend accepts.
  /// Spaces around it are ignored, so trim the value before sending it.
  static const Validator<dynamic> url = _UrlValidator();

  /// A price in LD above 0 with up to 3 decimals, as the backend takes it.
  static const Validator<dynamic> price = _PriceValidator();

  /// A whole number from [min] to [max] (typed as text; Arabic digits
  /// too). Read it with [wholeNumber].
  static Validator<dynamic> wholeNumberBetween(int min, int max) =>
      _WholeNumberValidator(min, max);

  /// The number in a field checked with [wholeNumberBetween], or null when
  /// it's empty.
  static int? wholeNumber(Object? value) {
    if (value is! String) return null;
    final digits = value.trim().replaceAllMapped(
      RegExp('[٠-٩]'),
      (match) => '${match[0]!.codeUnitAt(0) - 0x0660}',
    );
    return RegExp(r'^\d{1,9}$').hasMatch(digits) ? int.parse(digits) : null;
  }
}

class _WholeNumberValidator extends Validator<dynamic> {
  const _WholeNumberValidator(this.min, this.max);

  final int min;
  final int max;

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    if (value is! String || value.trim().isEmpty) return null;
    final number = SValidators.wholeNumber(value);
    return number != null && number >= min && number <= max
        ? null
        : {
            SValidators.wholeNumberKey: {'min': min, 'max': max},
          };
  }
}

class _PriceValidator extends Validator<dynamic> {
  const _PriceValidator();

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final value = control.value;
    if (value is! String || value.trim().isEmpty) return null;
    return parsePrice(value) == null ? {SValidators.priceKey: true} : null;
  }
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
