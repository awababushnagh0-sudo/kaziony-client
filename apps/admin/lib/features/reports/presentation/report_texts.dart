import '../../../core/l10n/generated/admin_localizations.dart';
import '../domain/customer_report.dart';

String reportReasonText(AdminLocalizations s, ReportReason reason) =>
    switch (reason) {
      ReportReason.storeClosed => s.reportReasonStoreClosed,
      ReportReason.notGiven => s.reportReasonNotGiven,
      ReportReason.priceDifferent => s.reportReasonPriceDifferent,
      ReportReason.quality => s.reportReasonQuality,
      ReportReason.other => s.reportReasonOther,
    };

/// Their name, or their email without one.
String customerText(AdminLocalizations s, ReportCustomer customer) =>
    customer.name ?? customer.email ?? s.reportDeletedAccount;

/// What resolving it took back.
String takenBackText(AdminLocalizations s, CustomerReport report) =>
    switch ((report.strikeRemoved, report.pauseEnded)) {
      (true, true) => s.reportTakenBoth,
      (true, false) => s.reportTakenStrike,
      (false, true) => s.reportTakenPause,
      (false, false) => s.reportTakenNothing,
    };
