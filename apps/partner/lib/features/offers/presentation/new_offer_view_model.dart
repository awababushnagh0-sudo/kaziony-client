import 'dart:async';

import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../home/presentation/home_view_model.dart';
import '../../products/domain/product.dart';
import '../../products/presentation/product_form_view_model.dart';
import '../../store/domain/current_store.dart';
import '../domain/offer.dart';
import 'offer_form_checks.dart';
import 'offer_view_model.dart';
import 'offers_view_model.dart';

/// The product to post from, and the ended offer it's posted again from.
typedef NewOfferArgs = ({String productId, String? fromOfferId});

class NewOfferState {
  const NewOfferState({
    required this.type,
    required this.discount,
    this.branchIds,
    this.posting = false,
    this.noBranch = false,
    this.failure,
  });

  final OfferType type;

  /// The discount the typed price gives, or null while it isn't a price.
  final int? discount;

  /// Null for all the store's branches.
  final Set<String>? branchIds;
  final bool posting;

  /// Every branch was unticked.
  final bool noBranch;
  final AppFailure? failure;
}

/// Posts an offer from a product. Its page has already loaded the product
/// (and the offer it reposts).
class NewOfferViewModel extends ViewModel<NewOfferState> {
  NewOfferViewModel(this.args);

  final NewOfferArgs args;

  late final FormGroup form;
  late final Product product;

  @override
  NewOfferState build() {
    product = ref.read(productViewModel(args.productId)).requireValue;
    final fromId = args.fromOfferId;
    final from = fromId == null
        ? null
        : ref.read(offerViewModel(fromId)).requireValue;
    final type = from?.type ?? OfferType.limited;
    form = FormGroup({
      'price': FormControl<String>(
        value: from?.offerPrice,
        validators: [
          Validators.required,
          SValidators.price,
          OfferChecks.belowRegular(product.regularPrice),
        ],
      ),
      'type': FormControl<OfferType>(value: type),
      'quantity': FormControl<String>(
        value: from?.totalQuantity?.toString(),
        validators: [SValidators.wholeNumberBetween(1, 10000)],
      ),
      'hold': FormControl<String>(
        value: '${from?.claimWindowMinutes ?? 60}',
        validators: [SValidators.wholeNumberBetween(15, 240)],
      ),
      'perCustomer': FormControl<String>(
        value: '${from?.maxPerUser ?? 1}',
        validators: [
          Validators.required,
          SValidators.wholeNumberBetween(1, 10),
        ],
      ),
      'endsAt': FormControl<DateTime>(
        value: OfferChecks.defaultEnd(),
        validators: [Validators.required, OfferChecks.endsAt],
      ),
    });
    _requireLimitedFields(type);
    final prices = form
        .control('price')
        .valueChanges
        .listen(
          (_) => state = NewOfferState(
            type: state.type,
            discount: _discount(),
            branchIds: state.branchIds,
          ),
        );
    ref.onDispose(() {
      unawaited(prices.cancel());
      form.dispose();
    });
    return NewOfferState(
      type: type,
      discount: _discount(),
      branchIds: from?.branchIds.toSet(),
    );
  }

  void setType(OfferType type) {
    _requireLimitedFields(type);
    state = NewOfferState(
      type: type,
      discount: state.discount,
      branchIds: state.branchIds,
    );
  }

  /// Ticks or unticks a branch; [all] are the store's active branches.
  void toggleBranch(String id, List<String> all) {
    final chosen = {...(state.branchIds ?? all.toSet())};
    if (!chosen.remove(id)) chosen.add(id);
    state = NewOfferState(
      type: state.type,
      discount: state.discount,
      branchIds: chosen.length == all.length ? null : chosen,
    );
  }

  /// Returns the posted offer, or null when it wasn't posted.
  Future<Offer?> post() async {
    if (state.posting) return null;
    final branchIds = state.branchIds;
    final noBranch = branchIds != null && branchIds.isEmpty;
    if (form.invalid || noBranch) {
      form.markAllAsTouched();
      state = NewOfferState(
        type: state.type,
        discount: state.discount,
        branchIds: branchIds,
        noBranch: noBranch,
      );
      return null;
    }
    final storeId = ref.read(currentStoreProvider)?.storeId;
    if (storeId == null) return null;
    state = NewOfferState(
      type: state.type,
      discount: state.discount,
      branchIds: branchIds,
      posting: true,
    );

    final limited = state.type == OfferType.limited;
    final result = await ref
        .read(offerRepositoryProvider)
        .create(
          storeId,
          NewOffer(
            productId: product.id,
            offerPrice: parsePrice(form.control('price').value as String)!,
            type: state.type,
            totalQuantity: limited ? _number('quantity') : null,
            claimWindowMinutes: limited ? _number('hold') : null,
            maxPerUser: _number('perCustomer')!,
            endsAt: form.control('endsAt').value as DateTime,
            branchIds: branchIds?.toList(),
          ),
        );
    if (!ref.mounted) return null;
    state = NewOfferState(
      type: state.type,
      discount: state.discount,
      branchIds: branchIds,
      failure: result.failureOrNull,
    );
    if (result.isOk) {
      ref
        ..invalidate(offersViewModel)
        ..invalidate(homeViewModel);
    }
    return result.valueOrNull;
  }

  /// Pieces and the hold time only count for limited offers.
  void _requireLimitedFields(OfferType type) {
    final limited = type == OfferType.limited;
    form
      ..control('quantity').setValidators([
        if (limited) Validators.required,
        SValidators.wholeNumberBetween(1, 10000),
      ], autoValidate: true)
      ..control('hold').setValidators([
        if (limited) Validators.required,
        SValidators.wholeNumberBetween(15, 240),
      ], autoValidate: true);
  }

  int? _discount() {
    final value = form.control('price').value;
    final price = value is String ? parsePrice(value) : null;
    return price == null
        ? null
        : discountPercent(original: product.regularPrice, offer: price);
  }

  int? _number(String name) =>
      SValidators.wholeNumber(form.control(name).value);
}

final newOfferViewModel = NotifierProvider.autoDispose
    .family<NewOfferViewModel, NewOfferState, NewOfferArgs>(
      NewOfferViewModel.new,
    );
