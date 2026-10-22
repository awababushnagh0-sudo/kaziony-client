/// Foundation shared by all apps. Apps import this instead of Flutter,
/// Riverpod, Dio, go_router, storage plugins, etc.
library;

// Layout and basic widgets (Row, Column, Padding, ...). Visual components
// come from `stellar`; apps never import material.dart. Raw text, icons and
// colors are hidden so apps can only use SText, SIcon and SColor tokens.
export 'package:flutter/widgets.dart'
    hide
        Color,
        DefaultTextStyle,
        FontWeight,
        Icon,
        IconData,
        IconTheme,
        RichText,
        Text,
        TextSpan,
        TextStyle;

export 'src/appearance/theme_choice.dart';
export 'src/auth/session.dart'
    show
        SessionController,
        SessionRestoring,
        SessionState,
        SignedIn,
        SignedOut,
        sessionProvider;
export 'src/auth/session_user.dart';
export 'src/bootstrap.dart';
export 'src/config/app_config.dart';
export 'src/dev/dev_log.dart';
export 'src/dev/dev_settings.dart';
export 'src/errors/error_reporter.dart';
export 'src/locale/locale.dart';
export 'src/navigation/leave_guard.dart';
export 'src/navigation/navigation.dart';
export 'src/network/api.dart';
export 'src/result/failure.dart';
export 'src/result/result.dart';
export 'src/state/state.dart';
export 'src/storage/storage.dart';
export 'src/utils/city.dart';
export 'src/utils/dates.dart';
export 'src/utils/money.dart';
export 'src/utils/phone.dart';
export 'src/version/version_gate.dart';
