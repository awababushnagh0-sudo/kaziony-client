import 'dart:async';

import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../home/presentation/home_view_model.dart';
import '../../store/domain/current_store.dart';
import '../domain/offer.dart';
import 'offer_form_checks.dart';
import 'offers_view_model.dart';

class NewOfferState {
  const NewOfferState({
    required this.type,
    required this.discount,
    required this.pieces,
    required this.hold,
    required this.perLimited,
    required this.perCustomer,
    required this.endsAt,
    this.branchIds,
    this.posting = false,
    this.failure,
  });

  final OfferType type;

  /// The discount the typed price gives, or null while it isn't a price.
  final int? discount;

  /// What the form holds now, for the lines that sum it up; null while
  /// it isn't a number yet. [pieces] are for limited offers only.
  final int? pieces;
  final int hold;
  final bool perLimited;
  final int? perCustomer;
  final DateTime? endsAt;

  /// Null for all the store's branches; empty when every one is unticked.
  final Set<String>? branchIds;
  final bool posting;
  final AppFailure? failure;
}

/// What both ways of posting an offer share: the offer's fields (its
/// price under the regular one, type, pieces, hold time, per customer and
/// end), its branches, and posting it for a product.
abstract class OfferDraftViewModel extends ViewModel<NewOfferState> {
  late final FormGroup form;

  /// The hold times to pick from: the usual ones, and the reposted
  /// offer's own when it's another.
  late final List<int> holdChoices;

  /// The usual hold times, in minutes.
  static const usualHolds = [30, 60, 120, 240];

  /// Pieces a new offer starts with: a few, to step up or type over.
  static const _firstPieces = 5;

  /// What a per-customer limit starts at once one is set.
  static const _firstPerCustomer = 2;

  /// The regular price ("8.000") the offer's must be under; null while
  /// there's none yet (typed on the form, for something new).
  String? get regularPrice;

  /// Builds [form] from the offer's fields and [extra] ones, filled from
  /// [from] when it's posted again; returns the first state. It ends
  /// tonight (or tomorrow night) either way: the old end is gone.
  NewOfferState buildForm({
    Offer? from,
    Map<String, AbstractControl<Object?>> extra = const {},
  }) {
    final type = from?.type ?? OfferType.limited;
    final hold = from?.claimWindowMinutes ?? 60;
    final perCustomer = from?.maxPerUser;
    holdChoices = {...usualHolds, hold}.toList()..sort();
    form = FormGroup({
      ...extra,
      'price': FormControl<String>(
        value: from?.offerPrice,
        validators: [
          Validators.required,
          SValidators.price,
          OfferChecks.belowRegularOf(() => regularPrice),
        ],
      ),
      'type': FormControl<OfferType>(value: type),
      'quantity': FormControl<String>(
        value: '${from?.totalQuantity ?? _firstPieces}',
      ),
      'hold': FormControl<int>(value: hold),
      // No limit per customer unless the store sets one: what matters is
      // that the pieces go, not who takes them.
      'perLimited': FormControl<bool>(value: perCustomer != null),
      'perCustomer': FormControl<String>(
        value: '${perCustomer ?? _firstPerCustomer}',
      ),
      'endsAt': FormControl<DateTime>(
        value: OfferChecks.defaultEnd(),
        validators: [Validators.required, OfferChecks.endsAt],
      ),
    });
    _requireLimitedFields(type);
    _requirePerCustomer(perLimited: perCustomer != null);
    final changes = form.valueChanges.listen(
      (_) => state = _snapshot(state.branchIds),
    );
    ref.onDispose(() {
      unawaited(changes.cancel());
      form.dispose();
    });
    return _snapshot(from?.branchIds.toSet());
  }

  void setType(OfferType type) => _requireLimitedFields(type);

  void setPerLimited(bool limited) => _requirePerCustomer(perLimited: limited);

  /// Ticks or unticks a branch; [all] are the store's active branches.
  void toggleBranch(String id, List<String> all) {
    final chosen = {...(state.branchIds ?? all.toSet())};
    if (!chosen.remove(id)) chosen.add(id);
    state = _snapshot(chosen.length == all.length ? null : chosen);
  }

  /// Ticks every branch, or unticks them all.
  void setAllBranches({required bool all}) =>
      state = _snapshot(all ? null : {});

  /// The store to post in, once everything's filled in right; null, with
  /// what's wrong marked, otherwise. Shows it's posting.
  String? startPosting() {
    if (state.posting) return null;
    final branchIds = state.branchIds;
    if (form.invalid || (branchIds != null && branchIds.isEmpty)) {
      form.markAllAsTouched();
      state = _snapshot(branchIds);
      return null;
    }
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return null;
    state = _snapshot(branchIds, posting: true);
    return storeId;
  }

  /// Ends posting with why it failed.
  void failPosting(AppFailure failure) =>
      state = _snapshot(state.branchIds, failure: failure);

  /// Posts the offer for [productId]; returns it, or null when it wasn't
  /// posted (the failure is in the state).
  Future<Offer?> postFor(String storeId, String productId) async {
    final limited = state.type == OfferType.limited;
    final branchIds = state.branchIds;
    final result = await ref
        .read(offerRepositoryProvider)
        .create(
          storeId,
          NewOffer(
            productId: productId,
            offerPrice: parsePrice(form.control('price').value as String)!,
            type: state.type,
            totalQuantity: limited ? _number('quantity') : null,
            claimWindowMinutes: limited ? state.hold : null,
            maxPerUser: state.perLimited ? _number('perCustomer') : null,
            endsAt: form.control('endsAt').value as DateTime,
            branchIds: branchIds?.toList(),
          ),
        );
    if (!ref.mounted) return null;
    state = _snapshot(branchIds, failure: result.failureOrNull);
    if (result.isOk) {
      ref
        ..invalidate(offersViewModel)
        ..invalidate(homeViewModel);
    }
    return result.valueOrNull;
  }

  /// The form as it is now, with the [branchIds] it posts in.
  NewOfferState _snapshot(
    Set<String>? branchIds, {
    bool posting = false,
    AppFailure? failure,
  }) {
    final type = form.control('type').value as OfferType;
    final perLimited = form.control('perLimited').value as bool;
    return NewOfferState(
      type: type,
      discount: _discount(),
      pieces: type == OfferType.limited ? _number('quantity') : null,
      hold: form.control('hold').value as int,
      perLimited: perLimited,
      perCustomer: perLimited ? _number('perCustomer') : null,
      endsAt: form.control('endsAt').value as DateTime?,
      branchIds: branchIds,
      posting: posting,
      failure: failure,
    );
  }

  /// Pieces only count for limited offers.
  void _requireLimitedFields(OfferType type) =>
      form.control('quantity').setValidators([
        if (type == OfferType.limited) Validators.required,
        SValidators.wholeNumberBetween(1, 10000),
      ], autoValidate: true);

  /// The number per customer only counts once there's a limit.
  void _requirePerCustomer({required bool perLimited}) =>
      form.control('perCustomer').setValidators([
        if (perLimited) Validators.required,
        SValidators.wholeNumberBetween(1, 10),
      ], autoValidate: true);

  int? _discount() {
    final value = form.control('price').value;
    final price = value is String ? parsePrice(value) : null;
    final regular = regularPrice;
    return price == null || regular == null
        ? null
        : discountPercent(original: regular, offer: price);
  }

  int? _number(String name) =>
      SValidators.wholeNumber(form.control(name).value);
}
