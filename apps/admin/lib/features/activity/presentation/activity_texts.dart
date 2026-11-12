import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/activity_entry.dart';

/// What [entry] did, in the dashboard's words. An action this version
/// doesn't know yet shows as the backend names it.
String activityActionText(AdminLocalizations s, ActivityEntry entry) =>
    switch (entry.action) {
      'store.create' => s.activityStoreCreate,
      'store.update' => s.activityStoreUpdate,
      'store.delete' => s.activityStoreDelete,
      'store.addLocation' => s.activityStoreAddLocation,
      'store.addMember' => s.activityStoreAddMember,
      'store.removeMember' => s.activityStoreRemoveMember,
      'store.setImage' => s.activityStoreSetImage,
      'store.removeImage' => s.activityStoreRemoveImage,
      'store.cancelBookings' => s.activityStoreCancelBookings,
      'user.create' => s.activityUserCreate,
      'user.update' => s.activityUserUpdate,
      'user.setStatus' =>
        _enabled(entry) ? s.activityUserEnable : s.activityUserDisable,
      'user.resetPassword' => s.activityUserResetPassword,
      'category.create' => s.activityCategoryCreate,
      'category.update' => s.activityCategoryUpdate,
      'serviceArea.create' => s.activityServiceAreaCreate,
      'serviceArea.update' => s.activityServiceAreaUpdate,
      'serviceArea.delete' => s.activityServiceAreaDelete,
      'settings.update' => s.activitySettingsUpdate,
      'offer.remove' => s.activityOfferRemove,
      'job.run' => s.activityJobRun,
      final other => other,
    };

/// The fields sent, at a glance: "name, phone, openingHours" (nested ones
/// by their top field).
String activityFieldsText(ActivityEntry entry) =>
    {for (final change in entry.changes) change.field.split('.').first}
        .join(', ');

bool _enabled(ActivityEntry entry) => entry.changes.any(
  (change) => change.field == 'isActive' && change.value == 'true',
);
