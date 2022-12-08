import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ppoa/business/state/system/system_state.dart';
import 'package:ppoa/client/routing/app_router.gr.dart';

extension SystemExtensions on SystemState {
  String getLocalizedErrorMessage(AppLocalizations localizations, AppRouter router) {
    if (currentException == null) {
      return '';
    }

    //TODO(ryan): Check error type and do switch statement with page
    String errorMessage = localizations.shared_errors_default;
    return errorMessage;
  }
}
