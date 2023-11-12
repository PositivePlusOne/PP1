// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/dialog_hint_helpers.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/account/account_confirm_password_page.dart';
import 'package:app/widgets/organisms/shared/positive_generic_page.dart';

@RoutePage()
class AccountDeleteProfilePage extends ConsumerStatefulWidget {
  const AccountDeleteProfilePage({super.key});

  @override
  ConsumerState<AccountDeleteProfilePage> createState() => _AccountDeleteProfilePageState();
}

class _AccountDeleteProfilePageState extends ConsumerState<AccountDeleteProfilePage> {
  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  set isDeleting(bool value) {
    _isDeleting = value;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> onContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onDeleteProfilePageConfirm');
    await appRouter.push(AccountConfirmPasswordRoute(pageType: AccountConfirmPageType.delete));
  }

  Future<void> onHelpRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    logger.i('Requesting delete profile help');
    final hint = fromTitleAndBulletPoints(
      localisations.page_account_actions_change_delete_account_body,
      [
        localisations.page_account_actions_change_delete_account_body_one,
        localisations.page_account_actions_change_delete_account_body_two,
        localisations.page_account_actions_change_delete_account_body_three,
        localisations.page_account_actions_change_delete_account_body_four,
        localisations.page_account_actions_change_delete_account_body_five,
        localisations.page_account_actions_change_delete_account_body_six,
        localisations.page_account_actions_change_delete_account_body_seven,
      ],
      boldFootnote: localisations.page_account_actions_change_delete_account_body_eight,
    );
    await appRouter.push(hint);
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    return PositiveGenericPage(
      title: localizations.page_account_actions_change_delete_account_splash_title,
      body: localizations.page_account_actions_change_delete_account_splash_body,
      buttonText: localizations.page_account_actions_change_delete_account_continue,
      isBusy: isDeleting,
      canBack: true,
      onHelpSelected: onHelpRequested,
      onContinueSelected: onContinueSelected,
    );
  }
}
