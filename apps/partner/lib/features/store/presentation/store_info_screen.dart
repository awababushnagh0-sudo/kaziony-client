import 'package:kernel/kernel.dart';
import 'package:stellar/stellar.dart';

import '../../../core/l10n/generated/partner_localizations.dart';
import '../../../core/widgets/store_image_field.dart';
import '../domain/current_store.dart';
import '../domain/store.dart';
import 'edit_store_info_view_model.dart';
import 'store_view_model.dart';

/// The store as customers see it. Owners edit what's theirs right here:
/// the pictures upload as soon as they're picked, and the pickup
/// instructions and contact details save with "Save changes", which shows
/// once something changed; leaving with changes asks first. The name and
/// category are our team's to change. Staff only read it.
class StoreInfoScreen extends AppView {
  const StoreInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = PartnerLocalizations.of(context);
    final store = ref.watch(storeViewModel);
    final isOwner = ref.watch(currentStoreProvider)?.isOwner ?? false;
    final edit = isOwner ? ref.watch(editStoreInfoViewModel) : null;

    Future<void> save() async {
      final saved = await ref.read(editStoreInfoViewModel.notifier).save();
      if (saved && context.mounted) SSnack.success(context, s.saved);
    }

    return LeaveGuard(
      active: edit?.changed ?? false,
      confirm: (context) => SDialog.confirm(
        context,
        title: s.discardChangesTitle,
        message: s.discardChangesMessage,
        confirmLabel: s.discardChanges,
        destructive: true,
      ),
      child: SScaffold(
        title: s.storeInfoTitle,
        bottom: edit != null && edit.changed
            ? SButton(
                label: s.saveChanges,
                onPressed: save,
                loading: edit.saving,
                expand: true,
              )
            : null,
        body: SAsyncView(
          value: store,
          onRetry: ref.read(storeViewModel.notifier).reload,
          loading: const SSkeleton.groups(groups: 3),
          builder: (context, store) => SingleChildScrollView(
            child: edit == null
                ? _ReadOnly(store)
                : SForm(
                    form: ref.read(editStoreInfoViewModel.notifier).form,
                    child: _Editable(store, edit: edit, onSave: save),
                  ),
          ),
        ),
      ),
    );
  }
}

/// The owner's page: the pictures to tap, what our team sets, and the
/// fields they can change.
class _Editable extends StatelessWidget {
  const _Editable(this.store, {required this.edit, required this.onSave});

  final Store store;
  final EditStoreInfoState edit;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final failure = edit.failure;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SCoverWithLogo(
          cover: StoreImageField(
            image: StoreImage.cover,
            url: store.coverUrl,
            editable: true,
          ),
          logo: StoreImageField(
            image: StoreImage.logo,
            url: store.logoUrl,
            editable: true,
          ),
        ),
        const Gap(Space.sm),
        SText.caption(s.storeImagesHint),
        const Gap(Space.xl),
        _Facts(store),
        const Gap(Space.sm),
        SText.caption(s.storeNameHint),
        const Gap(Space.xl),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: Space.lg,
          children: [
            STextInput(
              controlName: 'pickupInstructions',
              label: s.pickupInstructionsLabel,
              hint: s.pickupInstructionsHint,
              helper: s.pickupInstructionsHelper,
              kind: TextInputKind.multiline,
              maxLength: 500,
            ),
            STextInput(
              controlName: 'phone',
              label: s.phoneLabel,
              kind: TextInputKind.phone,
            ),
            STextInput(
              controlName: 'email',
              label: s.emailLabel,
              kind: TextInputKind.email,
            ),
            STextInput(
              controlName: 'facebookUrl',
              label: s.facebookLabel,
              kind: TextInputKind.url,
              hint: 'https://facebook.com/…',
            ),
            STextInput(
              controlName: 'instagramUrl',
              label: s.instagramLabel,
              kind: TextInputKind.url,
              hint: 'https://instagram.com/…',
              isLast: true,
              onSubmitted: onSave,
            ),
            if (failure != null)
              SText(failureMessage(context, failure), color: SColor.danger),
          ],
        ),
        const Gap(Space.sm),
        SText.caption(s.storeInfoHint),
      ],
    );
  }
}

/// Staff's page: the same facts, nothing to change.
class _ReadOnly extends StatelessWidget {
  const _ReadOnly(this.store);

  final Store store;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    final profile = store.profile;
    final phone = profile.phone;
    String shown(String? value) =>
        value == null || value.isEmpty ? s.notSet : value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (store.logoUrl != null || store.coverUrl != null) ...[
          SCoverWithLogo(
            cover: StoreImageField(
              image: StoreImage.cover,
              url: store.coverUrl,
              editable: false,
            ),
            logo: StoreImageField(
              image: StoreImage.logo,
              url: store.logoUrl,
              editable: false,
            ),
          ),
          const Gap(Space.xl),
        ],
        _Facts(store),
        const Gap(Space.xl),
        SListGroup(
          children: [
            SFactTile(
              label: s.pickupInstructionsLabel,
              value: shown(profile.pickupInstructions),
            ),
            SFactTile(
              label: s.phoneLabel,
              value: phone == null
                  ? s.notSet
                  // "091 000 0001" keeps its order in Arabic.
                  : '\u2066${formatLibyanPhone(phone)}\u2069',
            ),
            SFactTile(label: s.emailLabel, value: shown(profile.email)),
            SFactTile(
              label: s.facebookLabel,
              value: shown(profile.facebookUrl),
            ),
            SFactTile(
              label: s.instagramLabel,
              value: shown(profile.instagramUrl),
            ),
          ],
        ),
      ],
    );
  }
}

/// What our team sets, and what customers think of it.
class _Facts extends StatelessWidget {
  const _Facts(this.store);

  final Store store;

  @override
  Widget build(BuildContext context) {
    final s = PartnerLocalizations.of(context);
    return SListGroup(
      children: [
        SFactTile(label: s.storeNameLabel, value: store.name),
        SFactTile(
          label: s.categoryLabel,
          value: store.category.name(Localizations.localeOf(context)),
        ),
        SFactTile(
          label: s.ratingLabel,
          value: switch (store.ratingAverage) {
            final average? when store.ratingCount > 0 => s.ratingSummary(
              average,
              store.ratingCount,
            ),
            _ => s.noRatingsYet,
          },
        ),
      ],
    );
  }
}
