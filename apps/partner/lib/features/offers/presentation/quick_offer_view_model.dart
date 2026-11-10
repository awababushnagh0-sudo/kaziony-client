import 'dart:async';

import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../products/domain/product.dart';
import '../../products/presentation/product_photo_view_model.dart';
import '../../products/presentation/products_view_model.dart';
import '../domain/offer.dart';
import 'offer_draft_view_model.dart';

/// Posts an offer for something new: saves it as a product first (with
/// its photo), so it can be posted again in seconds next time.
class QuickOfferViewModel extends OfferDraftViewModel {
  /// Saved on the first try, so trying again posts the offer without
  /// saving a second product.
  Product? _product;

  @override
  String? regularPrice;

  @override
  NewOfferState build() {
    final first = buildForm(
      extra: {
        'title': FormControl<String>(
          validators: [Validators.required, Validators.maxLength(100)],
        ),
        'description': FormControl<String>(
          validators: [Validators.maxLength(1000)],
        ),
        'regular': FormControl<String>(
          validators: [Validators.required, SValidators.price],
        ),
      },
    );
    // The offer's price is checked against the regular one as it's typed.
    final regulars = form.control('regular').valueChanges.listen((value) {
      regularPrice = value is String ? parsePrice(value) : null;
      form.control('price').updateValueAndValidity();
    });
    ref.onDispose(() => unawaited(regulars.cancel()));
    return first;
  }

  /// Returns the posted offer, or null when it wasn't posted. Whether the
  /// photo went is the photo's own state: the offer is posted either way.
  Future<Offer?> post() async {
    final storeId = startPosting();
    if (storeId == null) return null;
    var product = _product;
    if (product == null) {
      final description = (form.control('description').value as String?)
          ?.trim();
      final saved = await ref
          .read(productRepositoryProvider)
          .create(
            storeId,
            ProductDraft(
              title: (form.control('title').value as String).trim(),
              description: description == null || description.isEmpty
                  ? null
                  : description,
              regularPrice: regularPrice!,
            ),
          );
      if (!ref.mounted) return null;
      switch (saved) {
        case Err(:final failure):
          failPosting(failure);
          return null;
        case Ok(:final value):
          product = _product = value;
          ref.invalidate(productsViewModel);
      }
    }
    await ref.read(productPhotoViewModel(null).notifier).uploadTo(product.id);
    if (!ref.mounted) return null;
    return postFor(storeId, product.id);
  }
}

final quickOfferViewModel =
    NotifierProvider.autoDispose<QuickOfferViewModel, NewOfferState>(
      QuickOfferViewModel.new,
    );
